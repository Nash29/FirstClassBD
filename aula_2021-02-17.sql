-- Comandos no BD aula_lab_bd_2021_1
create database banco_novo;

drop database banco_novo;

-- DATAS
-- Formato do SO: dd/mm/aaaa - 17/02/2021
-- Formato interno: aaaa-mm-dd - 2021-02-17
-- Hora: HH:MM:SS.ssss - 20:22 <-> 20:22:45.9034
-- Timestamp: 'aaaa-mm-dd HH:MM:SS.ssss'

-- CREATE TABLE
create table funcionario (
	cod_funcionario int primary key,
	nome varchar(100) not null,
	data_nascimento date,
	data_cadastro date not null,
	data_inicio date not null check (data_inicio >= data_cadastro),
	salario numeric(10,2) default 0.00,
	cpf bigint unique
);

create table dependente (
	cod_dependente serial primary key,
	nome varchar(100),
	data_nascimento date,
	cod_funcionario int 
	                references funcionario (cod_funcionario)
	                on delete restrict
	                on update cascade
);

insert into funcionario 
   (cod_funcionario, nome, data_nascimento, data_cadastro, 
	data_inicio, salario, cpf)
values
   (100, 'João da Silva', '1985-10-12', '10/01/2015', 
    '10/01/2015', 2000, 12345678900);
	
insert into funcionario 
   (cod_funcionario, nome, data_nascimento, data_cadastro, 
	data_inicio, salario, cpf)
values
   (200, 'Maria Josefina', '01/03/1990', '03/03/2017', 
    '05/03/2017', 2750.99, 341256879088),
   (300, 'Joaquim José', '10/07/1970', '12/09/2005',
    '15/09/2005', 4678.01, 89456712901);

-- Testando as restrições
--- Nome nulo (não fornecer um nome)
insert into funcionario 
   (cod_funcionario, data_nascimento, data_cadastro, 
	data_inicio, salario, cpf)
values
   (400, '04/06/1998', '09/08/2012', 
    '09/08/2012', 3465.90, 99988877766);

--- Data de início anterior a data de cadastro
insert into funcionario 
   (cod_funcionario, nome, data_nascimento, data_cadastro, 
	data_inicio, salario, cpf)
values
   (400, 'Ivo Ivonaldo', '04/06/1998', '09/08/2012', 
    '01/08/2012', 3465.90, 99988877766);

--- CPF duplicado
insert into funcionario 
   (cod_funcionario, nome, data_nascimento, data_cadastro, 
	data_inicio, salario, cpf)
values
   (400, 'Ivo Ivonaldo', '04/06/1998', '09/08/2012', 
    '09/08/2012', 3465.90, 12345678900);
	
--- Não informar um salário - preenche com valor padrão
insert into funcionario 
   (cod_funcionario, nome, data_nascimento, data_cadastro, 
	data_inicio, cpf)
values
   (400, 'Ivo Ivonaldo', '04/06/1998', '09/08/2012', 
    '09/08/2012', 99988877766);

select * from funcionario;

--- Inserir na tabela dependente
insert into dependente (nome, data_nascimento, cod_funcionario)
values ('Joãozinho', '14/09/2008', 100),
       ('Aninha', '18/09/2006', 100),
	   ('Chiquinho', '23/10/2010', 200),
	   ('Carlinhos', '30/12/2012', 300);
	   
--- Inserir um dependente para um funcionário que não existe
insert into dependente (nome, data_nascimento, cod_funcionario)
values ('Vitinho', '26/01/2004', 500);

-- Apagar funcionario que possui dependentes
delete from funcionario where cod_funcionario = 100;

-- Modificar o código de um funcionario que possui dependentes
update funcionario set cod_funcionario = 330 
   where cod_funcionario = 300;

select * from dependente;

------ ALTER TABLE
--- Modificar o nome da coluna
alter table dependente rename column nome to nome_dependente;

--- Modificar o nome da tabela
alter table dependente rename to dependentes;

select * from dependentes;

-- Adicionar um campo na tabela
alter table funcionario
  add column horas_mes varchar(3) default '200';

-- Apagar uma coluna
alter table funcionario
  drop column horas_mes;

-- Definir um valor padrão
alter table funcionario alter column salario set default 1000;

-- Excluir valor padrão
alter table funcionario alter column horas_mes drop default;

-- Modificar o tipo de dados da coluna horas_mes
alter table funcionario 
   alter column horas_mes type int using cast(horas_mes as int);

-- Adicionar uma restrição
alter table funcionario add check(horas_mes >= 100);

-- Excluir uma restrição
--  Obs: é necessário verificar o nome da restrição que se deseja
--       apagar (clicar na tabela e na aba SQL do pgAdmin)
alter table funcionario 
   drop constraint funcionario_horas_mes_check;

select * from funcionario;


---- APAGAR TABELA
drop table funcionario;

-- Forçar a exclusão
-- Apaga a tabela e a chave estrangeira
drop table funcionario cascade; 

-- recriando....
-- rodar CREATE TABLE
-- rodar os inserts
-- recriar a chave estrangeira
alter table dependentes
   add foreign key (cod_funcionario)
   references funcionario (cod_funcionario)
   on delete restrict
   on update cascade


--- Atualizando os valores de um campo
update funcionario
   set nome = 'Ivo Ivanogildo', data_nascimento = '27/09/1996',
       salario = 6832.98
   where cod_funcionario = 400;
select * from funcionario;

--- Excluir valores da tabela
delete from funcionario where cod_funcionario = 600;
