use CabinetMedical
go
select* from Angajat
select *from Pacienti
select*from Programari

go
---functie care testeaza daca salarul e mai mahre ca 0----------------------
create or alter function dbo.test_salar(@var int )
	returns INT
	as
	begin
		if (@var<=0) set @var=0
		else set @var=1
		return @var
end
go
----functie care testeaza daca numarul de telefon are 10 cifre-----------------------------
CREATE OR ALTER FUNCTION dbo.test_numar_tel(@numar_tel CHAR(10),@nr int)
	RETURNS INT
	AS
	BEGIN
		DECLARE @result INT;

		IF LEN(@numar_tel) = @nr
		BEGIN
			SET @result = 1;
		END
		ELSE
		BEGIN
			SET @result = 0;
		END;

		RETURN @result;
END;
go
----------------------functie care testeaza daca un input e varchar ------------------------------
create or alter function dbo.test_varchar(@var varchar)
	returns int 
	as 
	begin
		if(@var ='') SET @var=0
		else SET @var =1
		return @var
	end 
go
-------------functie care testeaza daca un input e mai mare ca 0 -----------------------------
create or alter function dbo.test_int(@int int)
	returns int 
	as 
	begin
		if(@int <0) SET @int=0
		else SET @int =1
		return @int 
end
go
----------functie care testeaza daca exista o cheie primara care sa corespunda foregnkey-ului -------------------
--1 -exista 
--0 -nu exista
create or alter function dbo.test_foregn_key_pacient(@key char(13))
returns int 
begin
	DECLARE @var int
	DECLARE @forReturn int 
	Set @var =(SELECT COUNT(*)
	FROM Pacienti
	WHERE cnp= @key);
	if (@var>0)
		begin
		SET @forReturn=1;
		end 
	else
		begin
		SET @forReturn=0;
		end
	return @forReturn;
end
go
----------functie care testeaza daca exista o cheie primara care sa corespunda foregnkey-ului -------------------
--1 -exista 
--0 -nu exista
create or alter function dbo.test_foregn_key_angajat(@key int)
returns int 
begin
DECLARE @var int
DECLARE @forReturn int 
Set @var =(SELECT COUNT(*)
FROM Angajat 
WHERE id_angajat= @key);
if (@var>0)
	begin
	SET @forReturn=1;
	end 
else
	begin
	SET @forReturn=0;
	end
return @forReturn;
end
go
----------functie care testeaza daca exista o cheie primara inserata in tabelul intermediar (aceeasi pereche) -------------------
--1 -exista 
--0 -nu exista
create or alter function dbo.test_existenta_chei_straine(@cheie_straina_1 int,@cheie_straina_2 char(13))
returns int 
begin
declare @forReturn int 
declare @var int 
set @var =(SELECT COUNT(*)
FROM Programari WHERE id_angajat = @cheie_straina_1 AND cnp =@cheie_straina_2);
if (@var>0)
	begin
	SET @forReturn=1;
	end 
else
	begin
	SET @forReturn=0;
	end
return @forReturn;
end
go 
create or alter procedure dbo.insert_angajat
	
	@table_name Varchar(50),
	@nume_angajat Varchar(200),
	@salar int,
	@specialitate Varchar(200),
	@numar_tel char(10),
	@succes int OUTPUT
as
begin
if (dbo.test_int(@salar)=0 or dbo.test_salar(@salar)=0)
begin 
print 'Error at insert procedure SALAR must not be <0 or =0 '
set @succes=0
return;
end 
if(dbo.test_varchar(@nume_angajat)=0 )
begin
print 'Error at insert procedure :NUME ANGAJAT must not be empty'
set @succes=0
return;
end
if(dbo.test_varchar(@specialitate)=0 )
begin
print 'Error at insert procedure :SPECIALITATE must not be empty'
set @succes=0
return;
end
if(dbo.test_numar_tel(@numar_tel,10)=0)
begin
print 'Error at insert procedure :NUMAR TEL must have ten digits'
set @succes=0
return;
end 
insert into Angajat(nume_angajat,salar,specialitate,numar_tel)
	Values(@nume_angajat,@salar,@specialitate,@numar_tel)
end 
--exec  dbo.insert_angajat 'Angajat','Marin',2000,'medic primar','012345789'-am verificat daca merge validarea 
go
----------functie care testeaza daca exista un angajat cu acea cheie primara  -------------------
--1 -exista 
--0 -nu exista
create or alter function dbo.tets_exist_angajat(@key int)
returns int 
begin 
declare @forReturn int
declare @var int 
set @var=(SELECT COUNT(*)
FROM Angajat WHERE id_angajat =@key);
if (@var>0)
	begin
	SET @forReturn=1;
	end 
else
	begin
	SET @forReturn=0;
	end
return @forReturn 
end
go
----------functie care testeaza daca exista un pacient cu acea cheie primara  -------------------
--1 -exista 
--0 -nu exista
create or alter function dbo.tets_exist_pacient(@key char(13))
returns int 
begin 
declare @forReturn int
declare @var int 
set @var=(SELECT COUNT(*)
FROM Pacienti WHERE  cnp=@key);
if (@var>0)
	begin
	SET @forReturn=1;
	end 
else
	begin
	SET @forReturn=0;
	end
return @forReturn 
end
go
create or alter procedure dbo.delete_angajat(@key int,@succes int OUTPUT )
as 
begin 
if(dbo.tets_exist_angajat(@key)=0)
begin
print 'Error at delete procedure : the angajat does not exist to be deleted '
set @succes=0
return;
end 
else 
begin
DELETE FROM Angajat
WHERE id_angajat= @key;
end 
end 
go
create or alter procedure dbo.delete_pacient (@key char(13), @succes int OUTPUT )
as 
begin 
if(dbo.tets_exist_pacient(@key)=0)
begin
print 'Error at delete procedure : the pacient does not exist to be deleted '
set @succes=0
return;
end 
else 
begin
DELETE FROM Pacienti
WHERE cnp=@key;
end 
end 
go

create or alter procedure dbo.insert_Pacient
	@cnp char(13),
	@nume_pacient varchar(200),
	@prenume_pacient varchar (200),
	@data_naster date,
	@sex varchar(50),
	@adresa varchar(400),
	@succes int OUTPUT
as 
BEGIN
	set @succes=1
	if(dbo.test_varchar(@nume_pacient)=0 )
	begin
	print 'Error at insert procedure :NUME PACIENT must not be empty'
	set @succes=0
	return;
	end
	if(dbo.test_varchar(@prenume_pacient)=0 )
	begin
	print 'Error at insert procedure :PRENUME PACIENT must not be empty'
	set @succes=0
	return;
	end
	if(dbo.test_varchar(@sex)=0 )
	begin
	print 'Error at insert procedure :SEX  must not be empty'
	set @succes=0
	return;
	end
	if(dbo.test_varchar(@adresa)=0 )
	begin
	print 'Error at insert procedure :ADRESA  must not be empty'
	set @succes=0
	return;
	end
	if (dbo.test_foregn_key_pacient(@cnp)=1)
	begin
	set @succes=0
		Raiserror( 'Error at insert procedure Programari :  cnp exist in Pacient ',16,1)
		return;
		return;
	end
	insert into Pacienti(cnp,nume_pacient,prenume_pacient,data_nastere,sex,adresa)
	Values(@cnp,@nume_pacient,@prenume_pacient,@data_naster,@sex,@adresa)
end 
go

create or alter procedure dbo.insert_programari 
	@cheie_straina_1 int,
	@cheie_straina_2 char(13) ,
	@data_programare date,
	@ora_programare time(7),
	@succes int OUTPUT
as
begin
	set @succes =1
	if (dbo.test_foregn_key_angajat(@cheie_straina_1)=0)
	begin 
	set @succes=0
		RAISERROR( 'Error at insert procedure Programari :  id_angajat does not exist in NAgajat ',16,1)
	
		return;
		return;
	end

	if (dbo.test_foregn_key_pacient(@cheie_straina_2)=0)
	begin
	set @succes=0
		Raiserror( 'Error at insert procedure Programari :  cnp does not exist in Pacient ',16,1)
	
		return;
		return;
	end
	if (dbo.test_existenta_chei_straine(@cheie_straina_1,@cheie_straina_2)=1)
	begin 
	set @succes=0
		RAISERROR('Error at insert procedure Programari : this pair exist ',16,1) ;
	return;
	return;
	end 
	print @succes
	insert into Programari(id_angajat, cnp,data_programare,ora_programare) values(@cheie_straina_1,@cheie_straina_2,@data_programare,@ora_programare)
end 
go
create or alter procedure dbo.delete_programare
@cheie_straina_1 int ,
@cheie_straina_2 char(13),
@succes int output
as
begin
if(dbo.test_existenta_chei_straine(@cheie_straina_1,@cheie_straina_2)=0)
begin
print 'Error at insert procedure Programari : this pair does not exist to be deleted ';
set @succes=0
return;
end
DELETE FROM Programari
 where id_angajat=@cheie_straina_1 and cnp=@cheie_straina_2
 end 
go
create  or alter procedure dbo.update_anagajat
@key int,
@table_name Varchar(50),
@nume_angajat Varchar(200),
	@salar int,
	@specialitate Varchar(200),
	@numar_tel char(10),
	@succes int OUTPUT
as 
begin
if(dbo.tets_exist_angajat(@key)=0)
begin 
print 'Error for update procedure : angajat does not exist to be update'
set @succes=0
return;
end

update Angajat set nume_angajat= @nume_angajat,salar=@salar,specialitate=@specialitate,numar_tel=@numar_tel
where id_angajat=@key;
end
go
create  or alter procedure dbo.update_pacient
@key char(13),
@nume_pacient varchar(200),
	@prenume_pacient varchar (200),
	@data_naster date,
	@sex varchar(50),
	@adresa varchar(400),
	@succes int output
as 
begin
if(dbo.tets_exist_pacient(@key)=0)
begin 
RAISERROR( 'Error for update procedure : pacient does not exist to be update',16,1)
set @succes=0
return;
return;
end
update Pacienti set nume_pacient= @nume_pacient,prenume_pacient= @prenume_pacient,data_nastere=@data_naster,sex=@sex,adresa=@adresa
where cnp=@key;
end
go
create or alter procedure dbo.update_programari 
	@cheie_straina_1 int,
	@cheie_straina_2 char(13) ,
	@data_programare date,
	@ora_programare time(7),
	@succes int output
as
begin
if (dbo.test_existenta_chei_straine(@cheie_straina_1,@cheie_straina_2)=0)
begin 
RAISERrOR( 'Error at update  procedure Programari : this pair does not exist  ',16,1);
set @succes=0
return;
return;
end 
update Programari set data_programare=@data_programare,ora_programare=@ora_programare
where cnp=@cheie_straina_2 and id_angajat=@cheie_straina_1
end 
go
create or alter procedure ultim_Angajat
@key int ,
@nume_angajat Varchar(200),
@salar int,
@specialitate Varchar(200),
@numar_tel char(10)
as 
begin
declare @out int 
exec dbo.insert_angajat 'Angajat',@nume_angajat,@salar,@specialitate,@numar_tel,@out OUTPUT
if(@out=0)
	begin
	return;
	return;
	end
select *from Angajat
set @key=(SELECT MAX(id_angajat) 
FROM Angajat);
exec dbo.update_anagajat @key,'Angajat','Alina',@salar,@specialitate,@numar_tel,@out OUTPUT 
if(@out=0)
	begin
	return;
	return;
	end
select *from Angajat
exec delete_angajat @key,@out OUTPUT
if(@out=0)
	begin
	return;
	return;
	end
select*from Angajat
end
go
create or alter procedure ultim_Pacient 
@key char (13) ,
@nume_pacient varchar(200),
@prenume_pacient varchar (200),
@data_naster date,
@sex varchar(50),
@adresa varchar(400)

as
	begin
	declare @out int 
	exec insert_Pacient @key, @nume_pacient,@prenume_pacient,@data_naster,@sex,@adresa,@out OUTPUT
	if(@out=0)
	begin
	return;
	return;
	end
	select *from Pacienti
	--set @key=(SELECT MAX(cnp) from Pacienti)
	exec update_pacient @key,'Pampam',@prenume_pacient,@data_naster,@sex,@adresa,@out OUTPUT
	if(@out=0)
	begin
	return;
	return;
	end
		select *from Pacienti
	exec delete_pacient @key,@out OUTPUT

	if(@out=0)
	begin
	return;
	return;
	end
	end
		select *from Pacienti
	go
create or alter procedure ultim_Programare
	@cheie_straina_1 int,
	@cheie_straina_2 char(13) ,
	@data_programare date,
	@ora_programare time(7)
as 
begin
declare @out int 
	exec insert_programari @cheie_straina_1,@cheie_straina_2,@data_programare,@ora_programare,@out OUTPUT
	print @out
	if(@out=0)
	begin
	return;
	return;
	end
	select *from Programari
	exec update_programari @cheie_straina_1,@cheie_straina_2,'2023-02-01',@ora_programare,@out OUTPUT
	print 'ok'
	print @out
	if(@out=0)
	begin
	return;
	return;
	end
		select *from Programari
	exec delete_programare @cheie_straina_1,@cheie_straina_2,@out OUTPUT
	print'ok'
	print @out
	if(@out=0)
	begin
	return;
	return;
	end
		select *from Programari
end
------------test corect pt angajat--------------------------------------------------------
EXEC ultim_Angajat 0,'NumeAngajatTest', 2500, 'MedicTest', '0123456789';
----exemple pt crud care dau exceptii-------------------
EXEC ultim_Angajat 0,'NumeAngajatTest', -1, 'MedicTest', '0123456789';
EXEC ultim_Angajat 0,'NumeAngajatTest', 2500, 'MedicTest', '012345679';
--------test corect pt pacient -----------------------------------------------------------------------
EXEC ultim_Pacient '123450789124', 'NumePacientTest3', 'PrenumePacientTest3', '19900101', 'M', 'AdresaTest3';
-------------test gresit pacient----------------------------------------------
EXEC ultim_Pacient '6034567890123', 'NumePacientTest3', 'PrenumePacientTest3', '19900101', 'M', 'AdresaTest3';
---------test corect pt programare ---------------------------------

exec ultim_Programare  5 ,'0234567890123','2023-03-12','12:00'
--------exemplu gresit pt introducere programare---------------------
EXEC ultim_Programare 7,'6034567890123','2023-01-01', '10:00';--perechea exista deja 
EXEC ultim_Programare 4,'6034567890123','2023-01-01', '10:00';--id_angajat=7 nu exista in in tabelul Angajati 
EXEC ultim_Programare 7,'2234567890123','2023-01-01', '10:00';--cnp nu exista in tabelul Pacineti
--cati pacienti au angajatii care incep cu litera s in pontaj
select *from Angajat
select* from Pacienti
select *from Programari
go
create view viewCrud_1
as 
SELECT a.nume_angajat ,COUNT(p.cnp) as Pacienti_per_luna
FROM Pacienti p INNER JOIN Programari prg on p.cnp=prg.cnp
INNER JOIN Angajat a on a.id_angajat=prg.id_angajat
GROUP BY a.nume_angajat Having  nume_angajat LIKE 'S%'

go
CREATE NONCLUSTERED INDEX N_ind_nume_angajat ON Angajat(nume_angajat);
go
--cate programari sunt facute inainte de 01.10.2023
create view viewCrud_2
as 

SELECT p.nume_pacient, prg.data_programare,a.nume_angajat
FROM Pacienti p INNER JOIN Programari prg on p.cnp=prg.cnp
INNER JOIN Angajat a on prg.id_angajat=a.id_angajat
WHERE prg.data_programare<'2023-10-01'
go
CREATE NONCLUSTERED INDEX N_inx_Pacient_nume ON Pacienti(nume_pacient);
go
create view ViewCrud_3
as 

SELECT p.nume_pacient from Pacienti p  where p.nume_pacient like 'S%'

go
CREATE NONCLUSTERED INDEX N_inx_Prog_data ON Programari(data_programare);
GO
IF EXISTS (SELECT name FROM sys.indexes WHERE name = N'N_inx_Prog_data')
DROP INDEX N_inx_Prog_data ON Programari;
IF EXISTS (SELECT name FROM sys.indexes WHERE name = N'N_inx_Pacient_nume')
DROP INDEX N_inx_Pacient_nume ON Pacienti;
select * from  viewCrud_1
select* from viewCrud_2
select*from  viewCrud_3
INSERT INTO Pacienti (cnp, nume_pacient, prenume_pacient, data_nastere, sex, adresa)
VALUES
    ('1111111111111', 'SNume1', 'Prenume1', '1990-01-01', 'M', 'Adresa1'),
    ('2222222222222', 'SNume2', 'Prenume2', '1985-02-15', 'F', 'Adresa2'),
    ('3333333333333', 'SNume3', 'Prenume3', '1992-07-10', 'M', 'Adresa3'),
    ('4444444444444', 'SNume4', 'Prenume4', '1988-05-20', 'F', 'Adresa4'),
    ('5555555555555', 'SNume5', 'Prenume5', '1995-11-30', 'M', 'Adresa5');
	INSERT INTO Pacienti (cnp, nume_pacient, prenume_pacient, data_nastere, sex, adresa)
VALUES
    ('6666666666666', 'AltNume1', 'AltPrenume1', '1993-04-05', 'F', 'O Alta Adresa11'),
    ('7777777777777', 'AltNume2', 'AltPrenume2', '1980-09-12', 'M', 'O Alta Adresa22'),
    ('8888888888888', 'AltNume3', 'AltPrenume3', '1987-03-18', 'F', 'O Alta Adresa33'),
    ('9999999999999', 'AltNume4', 'AltPrenume4', '1998-06-25', 'M', 'O Alta Adresa44'),
    ('1234567890123', 'AltNume5', 'AltPrenume5', '1982-11-08', 'F', 'O Alta Adresa55');
