# Data-Base-SQL
------------------------------------------------------------------------------
Lab 1-3
Aplicaţie simplă ce necesită o bază de date. Reprezentaţi datele 
aplicaţiei într-o structură relaţională şi implementaţi structura într-o bază de date 
Microsoft SQL Server. Baza de date trebuie să conţină cel puţin 10 tabele şi trebuie 
să împlementeze cel puţin o relaţie 1-m şi cel puţin o relaţie m-n.

Creaţi 10 interogări pe baza de date creată pentru primul laborator. Este necesar 
ca interogările să conţină cel puţin următoarele:
 - 5 interogări ce folosesc where
 - 3 interogări ce folosesc group by
 - 2 interogări ce folosesc distinct
 - 2 interogări cu having
 - 7 interogări ce extrag informaţii din mai mult de 2 tabele
 - 2 interogări pe tabele alfate în relaţie m-n.
Interogările trebuie să fie relevante pentru tema bazei de date şi vor returna 
informaţii utile unui potenţial utilizator.

Scrieţi un script SQL care va:
- modifica tipul unei coloane;
- adauga o costrângere de “valoare implicită” pentru un câmp;
- creea/şterge o tabelă;
- adăuga un câmp nou;
- creea/şterge o constrângere de cheie străină.
Aceste scripturi pot fi generate, însă va trebui să puteţi explica structura lor.
Pentru fiecare dintre scripturile de mai sus scrieţi/generaţi un alt script care 
implementează inversul operaţiei. De asemenea, creaţi o nouă tabelă care să 
memoreze versiunea structurii bazei de date (presupunând că acestă versiune este 
pur şi simplu un număr întreg).
Creaţi pentru fiecare din scripturi câte o procedură stocată şi asiguraţi-vă ca numele 
acestora să fie simplu şi clar.
De asemenea, scrieţi o altă procedură stocată ce primeşte ca parametru un număr 
de versiune şi aduce baza de date la versiunea respectivă.
-------------------------------------------------------------------------------------------------
TESTE
După finalizarea proiectării bazei de date, echipa de dezvoltare e interesată de 
obţinerea unor rezultate legate de performanţa acesteia. Pentru înregistrarea mai 
multor configuraţii de testare şi a rezultatelor rulării acestora se va creea 
următoarea structură relaţională:
 Tests – conţine informaţii despre diferite configuraţii de testare
 Tables – conţine listele tabelelor ce ar putea face parte din testare
 TestTables – este tabela de legătură dintre Tests şi Tables şi conţine lista 
tabelelor implicate în fiecare test
 Views – o muţime de view-uri existente în baza de date şi care sunt utilizate în 
testarea performanţei unor interogări particulare
 TestViews – este tabela de legătură dintre Tests şi Views şi conţine lista viewurilor implicate în fiecare test
 TestRuns – conţine rezultatele execuţiei diferitelor teste. Fiecare rulare de test 
presupune următoarele: 
 1) ştergerea datelor din tabelele asociate testului (în ordinea dată de 
câmpul Position); 
 2) inserarea înregistrărilor în tabele în ordinea inversă dată de Position 
(numărul de înregistrări inserate este dat de câmpul NoOfRows); 
 3) Evaluarea timpului de execuţie a view-urilor
 TestRunTables – conţine informaţii despre performanţa în care se inserării 
înregistrărilor fiecărei tabele asociate testului 
 TestRunViews – conţine informaţii despre performanţa fiecărei view din tese
---------------------------------------------------------------
Lab 6 
Creați operații CRUD încapsulate în proceduri stocate pentru cel puțin 3 tabele din 
baza de date (care să includă o relație many-to-many).
Trebuie să folosiți:
- parametri de intrare/ieșire;
- funcţii (de exemplu pentru formatarea/validarea datelor de intrare);
- constrângeri pe tabelă/coloană pentru a asigura validitatea datelor.
De asemenea, creați cel puțin 2 view-uri peste tabelele selectate pentru operațiile
CRUD. Pentru tabelele folosite în view, creați indecși non-clustered. Pentru a vă 
asigura că indecșii pe care i-ați creat sunt utili, puteți verifica utilizarea acestora cu 
Dynamic Management Views.
