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


create or replace function impedeAlteracao() returns trigger AS
$$
Declare
    x empregado.salario%type;
    y empregado.salario%type;
begin
    x = (OLD.salario/100)*50 + OLD.salario;
    y = old.salario - (OLD.salario/100)*50;
    IF (new.salario > x) then
        Raise exception 'Aumento não pode ser maior que 50%';
    ELSIF (new.salario < y) then
        Raise exception 'Aumento não pode ser maior que 50%';

    ELSE 
        return NEW;
    end if;
end;
$$ LANGUAGE 'plpgsql';

create trigger trig_limitador before update
on empregado for each row
execute procedure impedeAlteracao();


--Existe forma de passar parametro pela trigger?
