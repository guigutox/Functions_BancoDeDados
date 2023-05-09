--1 
create or replace function verificarSal()
returns Void as $$
BEGIN
	update empregado set salario = 4000 where salario < 4000;
END;
$$ LANGUAGE 'plpgsql';


--2
create or replace function manterSal()
returns trigger as $$
BEGIN
	if(new.salario < 4000) then
		new.salario = 4000;
		return new;
	END IF;
	if(new.salario > 8000) then
		new.salario = 7000;
		return new;
	END IF;
END;
$$ LANGUAGE 'plpgsql';


create trigger mantem_sal before insert
on empregado for each row
execute procedure manterSal();

--3 
create or replace function impedeAjuste()
returns trigger as 
$$
Declare
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

create or replace trigger trigAumento before update
on empregado for each row
execute procedure impedeAjuste();

--4
create or replace function empregadosNum()
returns trigger as 
$$ 
Declare
	dept_cod integer;
BEGIN
	dept_cod := NEW.numr_dept;
	IF (TG_OP = 'INSERT') THEN
		update departamento set num_empregados = num_empregados + 1 where codigo = dept_cod;
	ELSIF (TG_OP = 'DELETE') THEN
		update departamento set num_empregados = num_empregados - 1 where codigo = dept_cod;
	END if;
	return new;
END;
$$ language 'plpgsql';


create or replace trigger num_empregados 
after insert or delete on empregado
for each row
execute function empregadosNum();