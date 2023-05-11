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


Estrutura da função
Create function nome_funcao(parametro tipo)
returns tipo_retorno as
$$
--VARIAVEL GLOBAL
Declare
var tipo

--VARIAVEL DE REGISTRO que recebe varias colunas de uma tabela do tipo record
registro record; 


BEGIN
	--Declarar variavel
	nome_var tipo := valor;

	--Copiar tipo
	var varAcopiar%type -- Vai copiar o tipo da varivel

	--Printar no console
	raise notice 'STRING';

	--Jogar valor de consulta numa variavel
	select max(NUM) from tabela into var -- VARIAVEL var recebe o maior numero da coluna num

	--looping
	for var in select atributos from tabela loop

	end loop;

	--


	RETURN valor;
END;
$$ language plpgsql



--É possivel retornar uma tabela interia 
create or replace function retorna_pessoa() 
returns SETOF pessoa --SETOF indica que a função retorna um conjunto de registros de tipo pessoa
as $$
begin
	--Return query indica que ira retornara o resultado de uma query completa
	return query select * from pessoa;
End;
$$ language 'plpgsql';

create or replace function debuga()
returns void as 
$$
	begin
		raise debug 'Valor x = %', x; -- Raise debug escreve em um log
		raise notice 'Valor x = %', x; -- Raise notice manda uma mensagem e continua a execução
		raise exception 'Valor x = %', x; --Escreve no logo e termina a execução naquela parte
	end;
$$


--Estrutura do if

if num > then

elsif num < 0 then

else 

end if;


--Estrutura do for
declare
contador int := 1;

for contador in 1..5 loop
end loop

--For para percorrer linhas da tabela
Declare 
	linha record; -- record tipo generico
BEGIN
	For linha in select * from clientes loop

	raise notice 'Cliente: %', linha.nome;
	END loop;

END;


-- Estrutura do while
while contador <= 5 loop
	contador := contador + 1;
end loop;

--Estrutura do case

case
	when opcao = 1 then
	when opcao = 2 then
	when opcao = 3 then
	else
end case;


--TRIGGER ESTRUTURA

create or replace TRIGGER nome (before ou after)
(Evento insert, update ou delete)
on tabela for each (row ou statement)
execute procedure funcao(argumentos);

-- BEFORE = a trigger é chamada antes de ocorrer o evento definido geralmente definido antes dos dados serem atualizados ou inseridos

-- AFTER = a trigger é chamada depois do evento ocorrer  verificar integridade com outras tabelas ou propagar atualizações

--Insert tem acesso ao new apenas, update tem acesso ao new e old, delete tem acesso ao old apenas

-- TG OP Permite descobrir qual a ação e devolve o que esta acontecendo devolve em texto insert, update ou delete

--Return do before
--Return new para inset e update
-- Return old para delete
-- Para cancelar a operação return null

--After o tipo retornado é ignorado então deve ser null

--DATES e SUAS FUNÇÔES
--TIMESTAMP = Armazenar datas e horas espeficicas = 02-12-2002 09:00:00
--Interval = Armazenar um periodo de tempo ou sua duração = 34 anos, 2 horas 30 minutos.

--Age(timestamp, timestamp) = retorna a diferença de tempo de um para o outro, interval

--Age(timestamp) = retorna a diferença de tempo da data atual em relação a data passada, interval

--Current_date = retorna a data atual, date

--Current_time = hora atual, formato de hora

--Current_timestamp  = data e hora, time stamp

-- date_part(text, timestamp) = retorna parte selecionada da hora ex: date_parte('hour', timestamp'2001-02-16 20:38:40') = retornara 20 que é a hora

--date_part(text, interval) = retorna a parte selecionada porem agora de um timestamp.

--date_trunc() arredonda para baixo

--extarct(campo from timestamp) = retornara em integer a parte selecionada: extract(day from '2002-12-02') retornara 02

--extract(campo from interval) = retorna em integer a parte selecionada ex: extract(month from '2 years 3 months') = retornara 16

-- localtime // localtimestamp retonara hora local ou data e hora local

-- isinfinite = testa se é um intervalo finito e se for finiito devolve true

-- now() = data e hora correte

-- timeofday() = data e hora atual

-- ALTER TABLE nome_da_tabela ADD COLUMN nome_da_coluna tipo_de_dados;

-- ALTER TABLE nome_da_tabela DROP COLUMN nome_da_coluna;

-- ALTER TABLE nome_da_tabela ALTER COLUMN nome_da_coluna TYPE novo_tipo_de_dados;
