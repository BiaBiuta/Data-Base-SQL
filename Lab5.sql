use CabinetMedical
go
----1.Modify the type of a colulumn-----
SELECT* FROM FisaPacient
ALTER TABLE FisaPacient
ALTER COLUMN rezultatul_analize varchar(400)
print('am modificat coloana rezultatul_analize in varchar(400)')

----1i.Modify a coloumn-------------
SELECT* FROM FisaPacient
ALTER TABLE FisaPacient
ALTER COLUMN rezultatul_analize varchar(100)
print('am modificat coloana rezultatul_analize la valoarea initiala')
-----2.Adaugare constrangere-----------------------------------------
SELECT*FROM Vaccinari
ALTER TABLE Vaccinari
ADD CONSTRAINT df_today DEFAULT  GETDATE() FOR data_vaccinare
print('s-a adaugat constrangerea default de data curenta') 
-----2i.Stergere constrangere-----------------------------------------
ALTER TABLE Vaccinari
DROP CONSTRAINT df_today
print('s-a sters constrangerea default de data curenta')
-----3.Creare tabel---------------------------------------------------
CREATE TABLE facturi (
    id_factura INT PRIMARY KEY,
    data_emitere DATE,
    valoare DECIMAL(10, 2),
);
print('s-a creat cu suuces tabelul facturi')
-----3i.Stergere tabel facturi-----------------------------------------
DROP TABLE facturi
print('s-a sters cu suuces tabelul facturi')
------4.Adaug un camp nou-----------------------------------------------
ALTER TABLE facturi
ADD  id_anagajat int
print('am adaugat in tabela facturi id_angajatului')
------4i.Sterg camp nou--------------------------------------------------
ALTER TABLE facturi
DROP COLUMN id_angajat
print('am sters din tabela facturi id_angajatului')
------5.Constrangere de foreign key--------------------------------------
ALTER TABLE facturi
ADD CONSTRAINT fk_facturi  FOREIGN KEY (id_anagajat) REFERENCES Angajat(id_angajat)
print('Am adaugat foreign key-ul la id_anagajat')
------5i.Stergere constrangere de foreign key-----------------------------
ALTER TABLE facturi
DROP CONSTRAINT fk_facturi  
print('Am sters constrangerea foreign key-ul ')

----------------------------Proceduri-----------------------------------------------------

use CabinetMedical
go
----1.Modify the type of a colulumn-----
CREATE PROCEDURE do_procedure_1
AS
BEGIN
ALTER TABLE FisaPacient
ALTER COLUMN rezultatul_analize varchar(400)
print('am modificat coloana rezultatul_analize in varchar(400)')
exec setare 1
END
exec do_procedure_1
go
----1i.Modify a coloumn-------------
CREATE PROCEDURE undo_procedure_1
AS
BEGIN
ALTER TABLE FisaPacient
ALTER COLUMN rezultatul_analize varchar(100)
print('am modificat coloana rezultatul_analize la valoarea initiala')
exec setare 0
END
exec undo_procedure_1
go
-----2.Adaugare constrangere-----------------------------------------
CREATE PROCEDURE do_procedure_2
AS
BEGIN
ALTER TABLE Vaccinari
ADD CONSTRAINT df_today DEFAULT  GETDATE() FOR data_vaccinare
print('s-a adaugat constrangerea default de data curenta') 
exec setare 2
END
exec do_procedure_2
go
-----2i.Stergere constrangere-----------------------------------------
CREATE PROCEDURE undo_procedure_2
AS
BEGIN
ALTER TABLE Vaccinari
DROP CONSTRAINT df_today
print('s-a sters constrangerea default de data curenta')
exec setare 1
END
exec undo_procedure_2
go
-----3.Creare tabel---------------------------------------------------
CREATE PROCEDURE do_procedure_3
AS
BEGIN
CREATE TABLE facturi (
    id_factura INT PRIMARY KEY,
    data_emitere DATE,
    valoare DECIMAL(10, 2),
);
print('s-a creat cu suuces tabelul facturi')
exec setare 3
END
EXEC do_procedure_3
go
-----3i.Stergere tabel facturi-----------------------------------------
CREATE PROCEDURE undo_procedure_3 
AS
BEGIN
DROP TABLE facturi
print('s-a sters cu suuces tabelul facturi')
exec setare 2
END
exec undo_procedure_3
go
------4.Adaug un camp nou-----------------------------------------------
CREATE PROCEDURE do_procedure_4
AS 
BEGIN
ALTER TABLE facturi
ADD  id_anagajat int
print('am adaugat in tabela facturi id_angajatului')
exec setare 4
END
exec do_procedure_4
go
------4i.Sterg camp nou--------------------------------------------------
CREATE PROCEDURE undo_procedure_4
AS 
BEGIN
ALTER TABLE facturi
DROP COLUMN id_anagajat
print('am sters din tabela facturi id_angajatului')
exec setare 3
END
exec undo_procedure_4 
go 
------5.Constrangere de foreign key--------------------------------------
CREATE PROCEDURE do_procedure_5
AS 
BEGIN
ALTER TABLE facturi
ADD CONSTRAINT fk_facturi  FOREIGN KEY (id_anagajat) REFERENCES Angajat(id_angajat)
print('Am adaugat foreign key-ul la id_anagajat')
exec setare 5
END
exec do_procedure_5 
go
------5i.Stergere constrangere de foreign key-----------------------------
CREATE PROCEDURE undo_procedure_5
AS 
BEGIN
ALTER TABLE facturi
DROP CONSTRAINT fk_facturi  
print('Am sters constrangerea foreign key-ul ')
exec setare 4
END
exec undo_procedure_5 
go
CREATE TABLE Version(
	versionNo int
)
go
use CabinetMedical
go
--------------------------procedura setare versiune--------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE setare @versiune int
AS
BEGIN
UPDATE Version
SET versionNO=@versiune
END
exec setare 2

go
-------------procedura aflare versiune---------------------------------------------------
CREATE PROCEDURE aflare
@aflat INT OUTPUT
AS
BEGIN
SELECT @aflat=versionNo
FROM Version
END
GO
--------------------------------------procedura main-------------------------------------------------------------------
CREATE or ALTER PROCEDURE main @numar varchar(50)
AS
BEGIN
declare @run as int 
set @run=1
while (@run=1)
begin
	DECLARE @rezultat int
	exec aflare @aflat=@rezultat OUTPUT
	PRINT 'Sunt în versiunea: ' + CAST(@rezultat AS VARCHAR(10));
	IF TRY_CAST(@numar AS INT) IS NULL OR @numar <> CAST(@numar AS INT)
        BEGIN
            RAISERROR('trebuie sa fie intreg ',16,1)
            BREAK;
        END
	if(@numar>5)
		BEGIN
		print 'aici'
		RAISERROR('trebuie sa fie mai mic decat 5',16,1)
		BREAK;
		END
	if(@numar<0)
		BEGIN
		print 'aici'
		RAISERROR('trebuie sa fie mai mare decat 0',16,1)
		BREAK;
		END
	if(@numar=@rezultat)
		BEGIN
		PRINT 'ne aflam la acea versiune'
		SET @run=0;
		END
	else if(@numar>@rezultat)
		BEGIN
		WHILE(@numar>@rezultat)
			begin
			 PRINT @rezultat
			 DECLARE @text as varchar(50);
			 SET @text='dbo.do_procedure_'
			 DECLARE @index as int
			 SET @index=@rezultat+1
			 SET @text=@text+CAST(@index AS VARCHAR(10))
			 print(@text)
			 exec (@text)
			 SET @rezultat=@rezultat+1
			end
		SET @run=0;
		END
	else if(@numar<@rezultat)
		BEGIN
		WHILE(@numar<@rezultat AND @rezultat>0)
			begin
			 PRINT @rezultat
			 DECLARE @text1 as varchar(50);
			 SET @text1='dbo.undo_procedure_'
			 DECLARE @index1 as int
			 SET @index1=@rezultat
			 SET @text1=@text1+CAST(@index1 AS VARCHAR(10))
			 print(@text1)
			 exec (@text1)
			 SET @rezultat=@rezultat-1
			end
			SET @run=0;
		END
end
END
go
DECLARE @rezultat int
exec aflare @aflat=@rezultat OUTPUT
print @rezultat
exec main -20
--exec setare 0
DROP PROCEDURE main
select*from Version