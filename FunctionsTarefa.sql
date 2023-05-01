LISTA 3
--1
Create or Replace Function verificaSal()
returns Void AS $$
Declare
	registro RECORD;
BEGIN
	FOR registro in select id from empregado where salario < 3000 loop
		update empregado set salario = 3000 where id = registro.id;
	END LOOP;
End;
$$ LANGUAGE 'plpgsql';


--7
create or replace function atualizarSal(integer, numeric(10,2))
returns Void As $$

Begin
	Update empregado set salario = $2 where id = $1;
End;
$$ language 'plpgsql'

--8
create or replace function atualizarDepNome(integer, varchar(255))
returns Void As $$

Begin
	Update departamento set nome = $2 where codigo = $1;
End;
$$ language 'plpgsql'



Lista 4

--2

create function inserirEmpregado(cpf numeric(14), nome varchar(40), data_nasc date, sexo char, endereco varchar(100),salario numeric(12, 2), numr_dept numeric(5), cpf_super numeric(14))
returns Void AS $$
declare 
	registro RECORD;
begin
	select into registro empregado.cpf from empregado where empregado.cpf = $1;
	IF FOUND then
		Raise notice 'CPF já cadastrado';
		return;
	END IF;
	
	insert into empregado values($1, $2, $3, $4, $5, $6, $7, $8);
	Raise notice 'Empregado inserido com sucesso';
	
end;
$$ language 'plpgsql';


--5
create function descobrirIdade (numeric(14))
returns integer as $$
declare 
	idade integer;
	registro record;
	
begin
	select into registro empregado.cpf, data_nasc from empregado where empregado.cpf = $1 order by empregado.cpf asc limit 1;
	if found then
		select extract(YEAR FROM age(current_date, registro.data_nasc)) into idade;
		return idade;
	END if;
	
	Raise notice 'ERRO na operação';
	
end;
$$ language 'plpgsql';


--7
CREATE FUNCTION orcamento_folha_pagamento() 
RETURNS TABLE(departamento_nome VARCHAR(40), orcamento_folha NUMERIC(12,2)) AS
$$
BEGIN
    RETURN QUERY 
    SELECT d.nome AS departamento_nome, SUM(e.salario) AS orcamento_folha
    FROM empregado e
    JOIN departamento d ON e.numr_dept = codigo
    GROUP BY d.nome, d.orcamento;
END;
$$
LANGUAGE 'plpgsql';

