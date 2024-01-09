CREATE DATABASE CabinetMedical
go
USE CabinetMedical
GO
CREATE TABLE Angajat(
id_angajat INT PRIMARY KEY IDENTITY(1,1),
nume_angajat VARCHAR(200),
salar INT,
specialitate VARCHAR(200) UNIQUE,
numar_tel CHAR(10)
)
CREATE TABLE Pacienti(
cnp CHAR(13) PRIMARY KEY ,
nume_pacient VARCHAR(200),
prenume_pacient VARCHAR(200),C
data_nastere DATE ,
sex VARCHAR(50),
adresa VARCHAR(300) UNIQUE
)
CREATE TABLE Programare(
id_anagajat INT FOREIGN KEY REFERENCES Angajat(id_angajat),
cnp CHAR(13) FOREIGN KEY REFERENCES Pacienti(cnp),
data_programare DATE,
ora_programare TIME
)
DROP TABLE Programare
CREATE TABLE Programari(
id_angajat INT FOREIGN KEY REFERENCES Angajat(id_angajat),
cnp CHAR(13) FOREIGN KEY REFERENCES Pacienti(cnp),
data_programare DATE,
ora_programare TIME,
CONSTRAINT pk_Programari PRIMARY KEY (id_angajat,cnp)
)
CREATE TABLE Consultari(
id_angajat INT FOREIGN KEY REFERENCES Angajat(id_angajat),
cnp CHAR(13) FOREIGN KEY REFERENCES Pacienti(cnp),
CONSTRAINT pk_Consultari PRIMARY KEY (id_angajat,cnp),
 CONSTRAINT fk_cons FOREIGN KEY(id_angajat,cnp) REFERENCES Programari(id_angajat,cnp)
)
DROP TABLE Consultari
CREATE TABLE Consultari(
id_angajat INT FOREIGN KEY REFERENCES Angajat(id_angajat),
cnp CHAR(13) FOREIGN KEY REFERENCES Pacienti(cnp),
CONSTRAINT pk_Consultari PRIMARY KEY (id_angajat,cnp),
 CONSTRAINT fk_cons FOREIGN KEY(id_angajat,cnp) REFERENCES Programari(id_angajat,cnp)
)
DROP TABLE Consultari
CREATE TABLE Consultari(
id_angajat INT FOREIGN KEY REFERENCES Angajat(id_angajat),
cnp CHAR(13) FOREIGN KEY REFERENCES Pacienti(cnp),
simtome VARCHAR(300),
CONSTRAINT pk_Consultari PRIMARY KEY (id_angajat,cnp),
 CONSTRAINT fk_cons FOREIGN KEY(id_angajat,cnp) REFERENCES Programari(id_angajat,cnp)
)
DROP TABLE Consultari
CREATE TABLE Consultari(
id_angajat INT REFERENCES Angajat(id_angajat),
cnp CHAR(13) REFERENCES Pacienti(cnp),
simtome VARCHAR(300),
CONSTRAINT pk_Consultari PRIMARY KEY (id_angajat,cnp),
 CONSTRAINT fk_cons FOREIGN KEY(id_angajat,cnp) REFERENCES Programari(id_angajat,cnp)
)
DROP TABLE Consultari
CREATE TABLE Consultari(
id_angajat INT REFERENCES Angajat(id_angajat),
cnp CHAR(13) REFERENCES Pacienti(cnp),
simtome VARCHAR(300),
CONSTRAINT pk_Consultari PRIMARY KEY (id_angajat,cnp),
 CONSTRAINT fk_cons FOREIGN KEY(id_angajat,cnp) REFERENCES Programari(id_angajat,cnp)
)
DROP TABLE Consultari
CREATE TABLE Consultari(
id_angajat INT,
cnp CHAR(13) ,
simtome VARCHAR(300),
CONSTRAINT pk_Consultari PRIMARY KEY (id_angajat,cnp),
 CONSTRAINT fk_cons FOREIGN KEY(id_angajat,cnp) REFERENCES Programari(id_angajat,cnp)
)
CREATE TABLE Reteta(
id_reteta INT PRIMARY KEY IDENTITY(1,1),
dozare INT,
valabilitate TIME,
id_angajat INT,
cnp CHAR(13),
CONSTRAINT fk_reteta FOREIGN KEY (id_angajat,cnp) REFERENCES Consultari(id_angajat,cnp)
)
CREATE TABLE Medicamente(
cuprescriere BIT DEFAULT 0,
--ValoareBoolean AS CASE WHEN cuprescriere = 1 THEN 'true' ELSE 'false' END,
reactii_adversen VARCHAR(200)
)
drop table Medicamente
CREATE TABLE Medicamente(
id_medicamente INT PRIMARY KEY IDENTITY(100,1),
nume_medicament VARCHAR(100),
cuprescriere BIT DEFAULT 0,
--ValoareBoolean AS CASE WHEN cuprescriere = 1 THEN 'true' ELSE 'false' END,
reactii_adversen VARCHAR(200)
)
CREATE TABLE Prescrise(
id_medicamente INT FOREIGN KEY REFERENCES Medicamente(id_medicamente),
id_reteta INT FOREIGN KEY REFERENCES Reteta(id_reteta),
CONSTRAINT pk_Prescrise PRIMARY KEY (id_medicamente,id_reteta)
)
CREATE TABLE Vaccinuri (
id_vaccin INT PRIMARY KEY IDENTITY (1,1),
nume_vaccin VARCHAR(100),
boala_prevenita VARCHAR(100),
)
CREATE TABLE Vaccinari(
id_vaccin INT FOREIGN KEY REFERENCES Vaccinuri(id_vaccin),
CNP CHAR(13) FOREIGN KEY REFERENCES Pacienti(cnp),
data_vaccinare DATE
)
CREATE TABLE FisaPacient(
cnp CHAR(13) FOREIGN KEY REFERENCES Pacienti(cnp),
istoric_medical_fam VARCHAR(100),
istoric_alergii VARCHAR(100),
rezultatul_analize VARCHAR(100),
CONSTRAINT pk_FisaPacienti PRIMARY KEY (cnp)
)
drop table Vaccinari
CREATE TABLE Vaccinari(
id_vaccin INT FOREIGN KEY REFERENCES Vaccinuri(id_vaccin),
cnp CHAR(13) FOREIGN KEY REFERENCES Pacienti(cnp),
data_vaccinare DATE,
CONSTRAINT pk_Vaccinary PRIMARY KEY (id_vaccin,cnp)
)
INSERT INTO Pacienti(cnp,nume_pacient,prenume_pacient,data_nastere,sex,adresa)
VALUES(6012345678901,'Pop','Mihai','2000-01-10','barbat','mihai.pop@gmail.com')
,(6023456789012,'Motoc','Maria','2001-02-11','femeie','maria.motoc@gmail.com')
,(6034567890123,'Strungar','Dan','2000-03-17','barbat','dan.strungar@gmail.com')
,(6045678901234,'Sas','Calin','1997-03-18','barbat','calin.sas@gmail.com')
,(6056789012345,'Bob','Viviana','1974-12-28','femeie','viviana.bob@gmail.com')
,(6067890123456,'Trifan','Paul','1998-04-15','barbat','paul.trifan@gmail.com')
,(6078901234567,'Gheorgheni','Alin','1980-09-06','barbat','alin.gheorgheni@gmail.com')
select*FROM Pacienti
INSERT INTO Angajat(nume_angajat,salar,specialitate,numar_tel)
VALUES('Gigel Bogdan',3000,'medic_stagiar','0751782552'),('Sorin Florin',7000,'medic_pediatru','0752782352'),('George Vasile',12000,'medic_chirurg','0759876552'),('Sandra Bulock',7500,'medic_de_familie','0753338255'),('Alin Mazare',6000,'asistemt','0765832213'),('Ionescu Radu',4500,'anestezist','0751566752');
select*FROM Angajat
select*FROM Pacienti
INSERT INTO Programari(id_angajat,cnp,data_programare,ora_programare)
VALUES(6,6012345678901,'2023-10-30','14:00:00'),(6,6045678901234,'2023-09-13','10:00:00'),(6,6023456789012,'2023-10-20','15:00:00'),(7,6034567890123,'2023-09-25','14:30:00'),(7,6045678901234,'2023-10-30','14:30:00')
select*FROM Angajat
select*FROM Pacienti
select*FROM Programari
--1.cate programari sunt facute inainte de 01.10.2023
select*FROM Angajat
select*FROM Pacienti
select*FROM Programari
SELECT p.nume_pacient, p.prenume_pacient,prg.data_programare,a.nume_angajat,a.specialitate
FROM Pacienti p INNER JOIN Programari prg on p.cnp=prg.cnp
INNER JOIN Angajat a on prg.id_angajat=a.id_angajat
WHERE prg.data_programare<'2023-10-01'
INSERT INTO Alergii(nume_alergie,anotimp)
Values('Alergie la polen', 'Primăvară'),
('Alergie la praf', 'Vară'),
('Alergie la păr de animale', 'Toamnă'),
('Alergie la acarieni', 'Iarnă'),
('Alergie la fructe de pădure', 'Primăvară'),
('Alergie la ambrozie', 'Vară'),
('Alergie la mucegai', 'Toamnă'),
('Alergie la iarbă', 'Primăvară'),
('Alergie la fân', 'Vară'),
('Alergie la frunze căzute', 'Toamnă')
select*FROM Pacienti

SELECT * FROM Alergii
SELECT*FROM Pacienti
INSERT INTO ALERGILEPACIENTULUI(id_alergie,cnp)
VALUES(2020,6012345678901),
(2022,6023456789012),
(2021,6034567890123),
(2023,6012345678901),
(2024,6067890123456),
(2020,6078901234567)
--2.cati barbati sunt alergici vara --
SELECT*FROM Pacienti
SELECT*FROM ALERGILEPACIENTULUI
SELECT*FROM Alergii
SELECT p.nume_pacient,p.prenume_pacient,alerg.nume_alergie
FROM Pacienti p LEFT JOIN ALERGILEPACIENTULUI ap on p.cnp=ap.cnp
RIGHT JOIN Alergii alerg on ap.id_alergie=alerg.id_alergie
WHERE alerg.anotimp='Vară' AND p.sex='barbat'
Select* FROM Programari
INSERT INTO Consultari(id_angajat,cnp,simtome)
VALUES(6,6012345678901,'greata'),
(6,6023456789012,'ameteala'),
(6,6045678901234,'durere de spate'),
(7,6045678901234,'tahicardie')
DELETE FROM Consultari
SELECT*FROM Consultari
INSERT INTO Consultari(id_angajat,cnp,simtome)
VALUES(6,6012345678901,'greata'),
(6,6023456789012,'ameteala'),
(6,6045678901234,'durere de spate'),
(7,6045678901234,'tahicardie'),
(7,6034567890123,NULL)
SELECT*FROM Consultari;

SELECT*FROM Reteta
SELECT*FROM Reteta
SELECT*FROM Consultari
SELECT*FROM Programari
SELECT*FROM Pacienti
ALTER TABLE Reteta
DROP COLUMN valabilitate ;
ALTER TABLE Reteta
ADD  valabilitate DATE;
INSERT INTO Reteta(dozare,valabilitate,id_angajat,cnp)
Values(5,'2023-11-10',6,6023456789012)
,(10,'2023-11-12',6,6023456789012)
,(7,'2023-11-10',6,6045678901234)
,(15,'2023-11-05',7,6045678901234)
,(NULL,NULL,7,6034567890123)
SELECT*FROM Reteta
--3.care retete au valabilitate dupa 06.11.2023 si dozarea mai mica de 10 ml
SELECT*FROM Pacienti
SELECT*FROM Programari
SELECT*FROM Consultari
SELECT*FROM Reteta
SELECT p.nume_pacient,p.prenume_pacient,prg.data_programare,prg.ora_programare,cons.simtome,ret.dozare
FROM Pacienti p LEFT JOIN Programari prg on p.cnp=prg.cnp
RIGHT JOIN Consultari cons on prg.cnp=cons.cnp AND prg.id_angajat=cons.id_angajat
RIGHT JOIN Reteta ret on cons.id_angajat=ret.id_angajat AND cons.cnp=ret.cnp
WHERE  ret.valabilitate>'2023-11-06' AND dozare<10
--4.cati pacienti sunt alergici pe anotimp
SELECT*FROM Alergii
SELECT*FROM ALERGILEPACIENTULUI
SELECT*FROM Pacienti
SELECT a.anotimp,COUNT(p.cnp) as numar_persoane
FROM Alergii a INNER JOIN ALERGILEPACIENTULUI al on a.id_alergie=al.id_alergie 
INNER JOIN Pacienti p on p.Cnp=al.cnp
GROUP BY a.anotimp HAVING COUNT(p.cnp)>1
SELECT* from Alergii
--5.cati pacienti au angajatii care incep cu litera s in pontaj
SELECT*FROM Pacienti
SELECT*FROM Programari
SELECT*FROM Angajat
SELECT a.nume_angajat ,COUNT(p.cnp) as Pacienti_per_luna
FROM Pacienti p INNER JOIN Programari prg on p.cnp=prg.cnp
INNER JOIN Angajat a on a.id_angajat=prg.id_angajat
GROUP BY a.nume_angajat Having COUNT(p.cnp)>0 and nume_angajat LIKE 'S%'
--------------------------
INSERT INTO Medicamente(nume_medicament,cuprescriere,reactii_adversen)
VAlues('Paracetamol', 1, 'Somnolență, greață'),
('Ibuprofen', 1, 'Dureri de stomac, erupții cutanate'),
('Amoxicilină', 1, 'Alergii, diaree'),
('Omeprazol', 0, 'Greață, dureri de cap'),
('Loratadină', 0 ,'Uscăciune în gât, somnolență'),
('Insulină', 1, 'Hipoglicemie, umflături'),
('Aspirină', 1, 'Iritații ale stomacului, sângerări')
SELECT*FROM Medicamente
SELECT *FROM Reteta
--intorduc 8 valori in tabelul de legatura Prescrise
INSERT INTO Prescrise(id_medicamente,id_reteta)
VALUES(100,11),
(106,11),
(100,12),
(100,13),
(104,14),
(105,14),
(106,14),
(103,12)
--6.tabel cu id_reteta ,valabilitate reteta ,si numele medicamentului cu reactii adverse careia nu ii trebuie prescriera sepciala --
SELECT*FROM Reteta
SELECT*FROM Prescrise
SELECT*FROM Medicamente
SELECT DISTINCT ret.id_reteta,ret.valabilitate,med.nume_medicament,med.reactii_adversen
FROM Reteta ret LEFT JOIN Prescrise pre on ret.id_reteta=pre.id_reteta 
RIGHT JOIN Medicamente med on med.id_medicamente=pre.id_medicamente
WHERE med.cuprescriere=0
--7.pontajul medicamentelor prescrise--
--tabel cu numele medicamentului si numarul de persoane caruia i-a fost prescris,
--se afiseaza medicamentele care au fost prescrise mai mult de o data
SELECT * FROM Reteta
SELECT*FROM Prescrise
SELECT* FROM Medicamente
SELECT DISTINCT med.nume_medicament, COUNT(ret.id_reteta) as [pontaj_nr_prescrieri]
FROM Reteta ret LEFT JOIN Prescrise pre on ret.id_reteta=pre.id_reteta 
RIGHT JOIN Medicamente med on med.id_medicamente=pre.id_medicamente
WHERE med.cuprescriere=1 GROUP BY med.nume_medicament HAving COUNT(ret.id_reteta)>0

------------------------------------------------------------------------------------
INSERT INTO Vaccinuri(nume_vaccin, boala_prevenita)
VALUES
	('Vaccin Hepatita B', 'Hepatita B'),
	('Vaccin Tetanos', 'Tetanos'),
	('Vaccin Rubeola', 'Rubeola'),
	('Vaccin Varicela', 'Varicela'),
	('Vaccin Poliomielita', 'Poliomielita'),
	('Vaccin HPV', 'Cancer cervical'),
	('Vaccin Gripa', 'Gripa'),
	('Vaccin Pneumococic', 'Pneumonie'),
	('Vaccin Rujeola-Oreion-Parotita (ROR)', 'Rujeola, Oreion, Parotita'),
	('Vaccin Difterie', 'Difterie')
	SELECT*fROM  Vaccinuri
	SELECT*fROM  Pacienti
--inserez 6 inregistrari in tabela vaccinari--
INSERT INTO Vaccinari(cnp,id_vaccin,data_vaccinare)
VALUES (6012345678901,5,'2023-01-15'),
(6012345678901,1,'2023-04-28'),
(6012345678901,2,'2023-07-10'),
(6012345678901,4,'2023-09-22'),
(6034567890123,7,'2000-02-23'),
(6056789012345,7,'2001-02-23')

SELECT*fROM  Vaccinari
SELECT *FROM Alergii
SELECT *FROM ALERGILEPACIENTULUI
--8.tabel cu numele ,prnumele ,numele vaccinului si boala prevenita din prima jumatate de an(3 tabele +WHERE) --
SELECT*fROM  Vaccinari
SELECT *FROM Vaccinuri
SELECT *FROM Pacienti
SELECT p.nume_pacient,p.prenume_pacient, vaccin.nume_vaccin,vaccin.boala_prevenita
FROM Pacienti p INNER JOIN Vaccinari vaccinari on p.cnp=vaccinari.cnp 
INNER JOIN  Vaccinuri vaccin on vaccinari.id_vaccin=vaccin.id_vaccin
WHERE vaccinari.data_vaccinare BETWEEN '2023-01-01' AND '2023-06-30'
--9.toti pacinetii care au si alergii si vaccinuri
SELECT DISTINCT p.nume_pacient,p.prenume_pacient
FROM Vaccinuri vaccin LEFT JOIN Vaccinari vaccinari on vaccin.id_vaccin=vaccinari.id_vaccin 
RIGHT JOIN Pacienti p on p.cnp=vaccinari.cnp
LEFT JOIN ALERGILEPACIENTULUI alp on p.cnp=alp.cnp
RIGHT JOIN Alergii al on alp.id_alergie=al.id_alergie
WHERE vaccin.nume_vaccin IS NOT NULL
--10.cati pacienti programati in aceeasi zi--
SELECT prg.data_programare ,COUNT(p.cnp) as [programari_pe_zi]
FROM Pacienti p  INNER JOIN Programari prg on prg.cnp=p.cnp
INNER JOIN Angajat a on a.id_angajat=prg.id_angajat
GROUP BY  prg.data_programare
