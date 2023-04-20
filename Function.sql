--Funções basicas

Create function soma(num1 integer, num2 integer) --Declaração da função mais parametros
returns integer as -- declara o tipo de retorno
$$ -- abre e fecha o escopo da função equivale a chaves {}

Declare --indica declaração de variavel
    resultado integer := 0; --Variavel do tipo inteiro iniciando em 0

Begin -- Declara o inicio do bloco
    resultado := num1 + num2;
    return resultado; -- retorno efetivado da função
End; -- Fecha o bloco 
$$ language 'plpgsql'; --Declara qual a linguagem que está sendo utilizada



Create or Replace function NOVO_NMat()
returns integer as 
$$
Declare UltimoNumero Integer;
Begin
    select max(NMat)
    From Aluno
    Into UltimoNumero; --Atribui o valor do select MAX(Nmat) para a variavel Ultimo numero
    Return(UltimoNumero+1);
End;
$$ language 'plpgsql';



