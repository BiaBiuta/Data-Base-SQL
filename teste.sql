use CabinetMedical
insert into dbo.Tables (Name) values('Medicamente'),('Reteta'),('Prescrise')
select*from Tables
go
------------creare View 1 ->select pe tabela medicamente-----------------------------------
create View View_1 AS 
SELECT*
FROM Medicamente
go
select * from View_1

go
----------creare View 2 ->join pe doua tabele----------------------
create View View_2 As
select r.id_reteta,r.cnp,r.dozare,m.nume_medicament,m.cuprescriere
from Medicamente m Inner Join Prescrise p on p.id_medicamente=m.id_medicamente
inner join Reteta r on r.id_reteta=p.id_medicamente
go
-----------creare View_3 ->join pe 3 tabele cu group by
create View View_3 AS
SELECT DISTINCT med.nume_medicament, COUNT(ret.id_reteta) as [pontaj_nr_prescrieri]
FROM Reteta ret LEFT JOIN Prescrise pre on ret.id_reteta=pre.id_reteta 
RIGHT JOIN Medicamente med on med.id_medicamente=pre.id_medicamente
WHERE med.cuprescriere=1 GROUP BY med.nume_medicament HAving COUNT(ret.id_reteta)>0
go

insert into dbo.Views(Name) values('View_1'),('View_2'),('View_3')
select *from Views
go
-------Adaug testele de efectuat in tabela Tests---------------
INSERT INTO Tests values
('test1'),('test2'),('test3')
go
Select* from Tests;
select *from Tables;
-------fac legatura intre teste si tabele-------------------
insert into TestViews values(3,1),(3,2),(3,3)
insert into TestTables values
(1,1,10,1),(1,2,10,2),(1,3,10,3),
(2,1,100,3),(2,2,10,2),(2,3,10,1);
select*from TestTables
select *from TestViews
go
-------prima procedura de inserare in tabelul Medicamente--------------
create procedure ins_1
@position int
As
BEGIN
	SET NOCOUNT ON;
	DECLARE @nume_medicament VARCHAR(100);
	DECLARE @cuprescriere bit ;
	DECLARE @reactii_adverse varchar(200);
	DECLARE @n int
	Declare @NoOfRows int
	SELECT TOP 1 @NoOfRows=NoOfRows from dbo.TestTables where Position=@position and TestID=1
	set @n=1
	while @n<=@NoOfRows
	begin
		SET @nume_medicament='Medicament'+CONVERT(Varchar(5),@n)
		declare @par INT
		set @par=@n%2
		if(@par=0)
			begin
			set @cuprescriere=1
			end
	    if(@par=1)
		begin
		set @cuprescriere=0
		end
		set @reactii_adverse='Reactie'+CONVERT(Varchar(5),@n)
		Insert into Medicamente(nume_medicament,cuprescriere,reactii_adversen) values(@nume_medicament,@cuprescriere,@reactii_adverse)
		set @n=@n+1
	end
	PRINT 'S-au inserat ' + CONVERT(VARCHAR(10), @NoOfRows) + ' valori in Medicamente';
END
drop procedure ins_1
exec ins_1 1
select * from Medicamente
go
----------creare procedura pentru inserare in tabelul Consultari----------------
create procedure ins_2
@position int 
As
BEGIN
declare @dozare int
declare @valabilitate date
set @valabilitate='2023-01-01'
DECLARE @fk int 
DECLARE @n int 
declare @NoOfRows int
SELECT TOP 1 @NoOfRows=NoOfRows from dbo.TestTables where Position=@position and TestID=1
set @n=1
Declare @fk1 char(13)
SELECT TOP 1 @fk=Max(id_angajat) from Consultari
Select Top 1 @fk1=c.cnp from Consultari c where c.id_angajat=@fk
while @n<=@NoOfRows
BEGIN
	SET @dozare=@n+100
	Set @valabilitate=dateadd(month,1,@valabilitate)
	insert into Reteta (dozare,id_angajat,cnp,valabilitate)values (@dozare,@fk,@fk1,@valabilitate)
	set @n=@n+1
END
PRINT 'S-au inserat ' + CONVERT(VARCHAR(10), @NoOfRows) + ' valori in Reteta';
END
go
drop procedure ins_2
exec ins_2 2
select*from Reteta

select *from TestTables
go
CREATE PROCEDURE ins_3
   @position int
AS
BEGIN
	declare @NoOfRows int
SELECT TOP 1 @NoOfRows=NoOfRows from dbo.TestTables where TestID=1 and Position=@position
    DECLARE @id_medicamente INT 
    DECLARE @id_reteta INT 
    declare @n int
	set @n=1
    WHILE @NoOfRows >= @n  
    BEGIN
        -- Alegeți un id_medicamente și un id_reteta
        SELECT TOP 1 @id_medicamente = id_medicamente
        FROM Medicamente
        ORDER BY NEWID(); -- NEWID() generează un identificator unic

        SELECT TOP 1 @id_reteta = id_reteta
        FROM Reteta
        ORDER BY NEWID();

        -- Adăugați înregistrarea în tabela Prescrise
        IF NOT EXISTS (SELECT 1 FROM Prescrise WHERE id_medicamente = @id_medicamente AND id_reteta = @id_reteta)
        BEGIN
            -- Adăugați înregistrarea în tabela Prescrise
            INSERT INTO Prescrise (id_medicamente, id_reteta)
            VALUES (@id_medicamente, @id_reteta);

            SET @n = @n + 1
        END
    END
END
drop procedure ins_3
exec ins_3 3
------------creez procedurile de stergere---------------------
select *from Prescrise
go
delete from Prescrise
go
create procedure del_1
@position int 
as
begin
declare @NoOfRows int
SELECT TOP 1 @NoOfRows=NoOfRows from dbo.TestTables where  TestID=2 and Position=@position
delete  from Prescrise 
where id_medicamente in(
Select TOP (@NoOfRows) id_medicamente from Prescrise)
end
drop procedure del_1
exec del_1 1
go

create procedure del_2
@position int 
As
begin
declare @NoOfRows int
SELECT TOP 1 @NoOfRows=NoOfRows from dbo.TestTables where  TestID=2 and Position=@position

DELETE FROM Reteta
WHERE id_reteta IN (SELECT TOP (@NoOfRows) id_reteta FROM Reteta ORDER BY id_reteta DESC );

end
exec del_2 2
select*from Reteta
go
create procedure del_3
@position int 
As 
begin
declare @NoOfRows int
SELECT TOP 1 @NoOfRows=NoOfRows from dbo.TestTables where  TestID=2 and Position=@position
DECLARE @NoOfRowsBefore INT;
SET @NoOfRowsBefore = (SELECT COUNT(*) FROM Medicamente);
if (@NoOfRowsBefore>=@NoOfRows)
begin
	DELETE FROM Medicamente
	WHERE id_medicamente IN (SELECT TOP (@NoOfRows) id_medicamente FROM Medicamente ORDER BY id_medicamente DESC );
end
if(@NoOfRowsBefore<@NoOfRows)
begin
	DELETE FROM Medicamente
	WHERE id_medicamente IN (SELECT TOP (@NoOfRowsBefore) id_medicamente FROM Medicamente ORDER BY id_medicamente DESC );
end
end 

exec del_3 3
select* from TestTables
go
select * from Medicamente
select * from Reteta
select * from Prescrise
select* from TestViews
select*from Tests
select* from Tables
go
select* from TestRuns
go
create or alter procedure test1
@id_test int 
As 
BEGIN
DECLARE @position int
DECLARE @position1 int 
declare @name_procedure varchar (10)
set @name_procedure='ins_'
set @position =(Select min(Position) from TestTables where TestID=1)
set @position1=(Select max(Position) from TestTables where TestID=1)
if(@id_test=1)
begin
	while(@position<=@position1)
	begin
		set @name_procedure=@name_procedure+CONVERT(Varchar(5),@position)
		exec @name_procedure @position
		set @position=@position+1
		set @name_procedure='ins_'
	end
end
if(@id_test=2)
begin
	set @name_procedure='del_'
	while(@position<=@position1)
	begin
		set @name_procedure=@name_procedure+CONVERT(Varchar(5),@position)
		exec @name_procedure @position
		set @position=@position+1
		set @name_procedure='del_'
	end
end
if(@id_test=3)
begin
	set @name_procedure='View_'
	while(@position<=@position1)
	begin
		set @name_procedure=@name_procedure+CONVERT(Varchar(5),@position)
		exec @name_procedure @position
		set @position=@position+1
		set @name_procedure='View_'
	end
end
END
exec test1 1
exec test1 2
go
create procedure test_1
@id_test int 
AS
begin
declare @position int 
declare @table_name nvarchar(50)
set @table_name ='Medicamente'
set @position =(select Position from Tables t inner join TestTables tt on t.Name=(@table_name) and t.TableID=tt.TableID and tt.TestID=@id_test )
print @position
declare @name_procedure varchar (10)
if(@id_test=1)
begin
declare @name_procedure1 varchar (10)
set @name_procedure1='ins_'
set @name_procedure1=@name_procedure1+CONVERT(Varchar(5),@position)
		exec @name_procedure1 @position
		--set @position=@position+1
		set @name_procedure1='ins_'
end
if(@id_test=2)
begin
declare @name_procedure2 varchar (10)
set @name_procedure2='del_'
set @name_procedure2=@name_procedure2+CONVERT(Varchar(5),@position)
		exec @name_procedure2 @position
		--set @position=@position+1
		set @name_procedure1='del_'
end
if (@id_test=3)
begin
	DECLARE @name_view nvarchar(50)
	set @name_view='View_'
	SET @name_view=@name_view+convert(varchar(5),@position)
	select @name_view
	set @name_view='View_'
end
END
select * from Views
create_procedure test_runs
@id_test int 
as
begin
declare @n int
set @n=1
while(@n<=3)
begin

	declare @ds DATETIME
	declare @di DATETIME
	declare @de DATETIME
	declare @test varchar(10)
	set @test='test1'
	--set @test=@test+convert(varchar(5),@n)
	set @ds=GETDATE()
	exec @test 1
	exec @test 2 
	set @di=GETDATE()
	exec @test 1
	exec @test 3
	exec @test 2
	set  @de =GETDATE()
	declare @name_tabel varchar(10)
	set @name_tabel=(select Name from Tables where TableID=@id_test)
	declare @cheie_straina1_tables int
	declare @cheie_straina2_tables int
	
	declare @description varchar (100)
	set @description='test pentru '+@table_name
	insert into TestRuns(Description,StartAt,EndAt) values(@description,@ds,@de)
	set @cheie_straina1_tables= (select TestRunId from TestRuns where Description ='%'+@table_name+'%')
	set @cheie_straina2_tables=(select TableID from Tables where Name=@table_name)
	insert into TestRunTables(TestRunID,TableID,StartAt,EndAt) values(@cheie_straina1_tables,@cheie_straina2_tables,@ds,@di)

end
end
go
create or alter procedure test_runs1 
as 
begin
Declare @n int
set @n=1
while(@n<=3)
begin
	print @n
	declare @ds DATETIME
	declare @di DATETIME
	declare @de DATETIME
	declare @test varchar(10)
	declare @view varchar(10)
	set @view ='View_'
	set @view=@view +convert(varchar(5),@n)
	set @test='test1'
	set @ds=GETDATE()
	exec @test 1
	exec @test 2 
	set @di=GETDATE()
	exec @test 1
	EXEC('SELECT * FROM ' + @view)
	exec @test 2
	set  @de =GETDATE()
	declare @cheie_straina1_tables int
	declare @cheie_straina2_tables int
	declare @description nvarchar (100)
	set @description='test pentru '+@view
	insert into TestRuns(Description,StartAt,EndAt) values(@description,@ds,@de)
	set @cheie_straina1_tables= (select  Top 1 TestRunID from TestRuns t where t.Description like '%'+@view )
	set @cheie_straina2_tables=(select Top 1 TableID from Tables t Inner Join TestRuns tt on TestRunID=@cheie_straina1_tables)
	insert into TestRunTables(TestRunID,TableID,StartAt,EndAt) values(@cheie_straina1_tables,@cheie_straina2_tables,@ds,@di)
	declare @cheie_straina_3 varchar(10)
	set @cheie_straina_3=(Select Top 1 ViewID from Views where Name=@view)
	insert into TestRunViews(TestRunID,ViewID,StartAt,EndAt)values(@cheie_straina1_tables,@cheie_straina_3,@di,@de)
	set @n=@n+1
end
end
exec test_runs1


select*from Tables
select *from Views
select*from TestTables
select * from Medicamente
select * from Reteta
select * from Prescrise
select *from TestRuns
select *from TestRunTables
select *from TestRunViews
delete from   TestRuns
delete from TestRunTables
delete from TestRunViews