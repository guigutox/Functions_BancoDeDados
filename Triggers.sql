
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

--EX 3


create or replace function impedeAlteracao() returns trigger AS
$$
Declare
    x empregado.salario%type;
begin
    x = 


end;





--Existe forma de passar parametro pela trigger?
