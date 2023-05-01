--LISTA 1

--EX 2
create or replace function arrumaSal() returns trigger AS
$$
begin 
if(new.salario < 3000) then 
new.salario = 3000;
end if;
return NEW;
END;
$$ LANGUAGE 'plpgsql';


create trigger trig_sal before insert 
on empregado for each row
execute procedure arrumaSal();

drop trigger trig_sal on empregado;
drop function arrumaSal;


select *  from empregado;

insert into empregado values (112345656, 'Alberto', '1990-01-01', 'M', 'Rua alguma coisa', 1000, 1, 11111111111);

--EX 3


CREATE OR REPLACE FUNCTION impedeAlteracao() RETURNS TRIGGER AS $$
DECLARE
    x empregado.salario%TYPE;
    y empregado.salario%TYPE;
BEGIN
    x := (OLD.salario / 100) * 50 + OLD.salario;
    y := OLD.salario - (OLD.salario / 100) * 50;
    IF (NEW.salario > x) THEN
        RAISE EXCEPTION 'Aumento não pode ser maior que 50%%. Salário máximo permitido: %', x;
    ELSIF (NEW.salario < y) THEN
        RAISE EXCEPTION 'Redução não pode ser maior que 50%%. Salário mínimo permitido: %', y;
    ELSE 
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER trig_limitador BEFORE UPDATE ON empregado
FOR EACH ROW EXECUTE PROCEDURE impedeAlteracao();


--Existe forma de passar parametro pela trigger?


--EX 4

ALTER TABLE departamento ADD COLUMN num_empregados INTEGER DEFAULT 0;


UPDATE departamento d
SET num_empregados = (
    SELECT COUNT(*) FROM empregado e
    WHERE e.numr_dept = d.codigo
);

select * from departamento;

CREATE OR REPLACE FUNCTION atualizaNumEmpregados() RETURNS TRIGGER AS
$$
DECLARE
    dept_codigo INTEGER;
BEGIN
    dept_codigo := NEW.numr_dept;
    IF (TG_OP = 'INSERT') THEN
        UPDATE departamento SET num_empregados = num_empregados + 1 WHERE codigo = dept_codigo;
    ELSIF (TG_OP = 'DELETE') THEN
        UPDATE departamento SET num_empregados = num_empregados - 1 WHERE codigo = dept_codigo;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER atualiza_num_empregados_trigger
AFTER INSERT OR DELETE ON empregado
FOR EACH ROW
EXECUTE FUNCTION atualizaNumEmpregados();

--EX 5
CREATE TABLE projeto (
    id_proj integer PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL,
    orcamento float NOT NULL,
    data_inicio DATE NOT NULL,
    duracao_prevista INTEGER NOT NULL
);

CREATE TABLE empregado_projeto (
    emp_cpf numeric(14,2) REFERENCES empregado(cpf),
    proj_id INTEGER REFERENCES projeto(id_proj),
    horas_mensais INTEGER NOT NULL,
    PRIMARY KEY(emp_cpf, proj_id)
);

create or replace function horasMinimas() returns trigger as
$$
begin
	if(new.horas_mensais < 10) then
	new.horas_mensais := 10;
	end if;
	return new;
end;
$$ LANGUAGE 'plpgsql';
	  
	 
CREATE TRIGGER manterHoras
before INSERT OR UPDATE ON empregado_projeto
FOR EACH ROW
EXECUTE FUNCTION horasMinimas();

--EX 6
CREATE OR REPLACE FUNCTION excluiEmpregado() RETURNS TRIGGER AS
$$
DECLARE
    cpf_del INTEGER;
BEGIN
    cpf_del := OLD.cpf;
	
	Delete from empregado_projeto where emp_cpf = cpf_del;
	
	if NOT exists(select * from dependente where emp_cpf = cpf_del) then
		INSERT INTO dependente(nome, parentesco, emp_cpf) VALUES ('NOME', 'Filho', emp_cpf);
	end if;
	
	delete from dependente where emp_cpf = cpf_del;
	
	return old;
end;
$$ language 'plpgsql';

create trigger exclui_empregado_trigger
before delete on empregado
for each row 
execute function excluiEmpregado();