-- Aufgabe 3
-- 3a)
select count(distinct quali) as anz from  Pilot 

-- 3b)
select avg(geschw) as d_geschw from Fztyp natural join Maschine natural join Bestand where gesell_bez = 'LUFTHANSA'

-- 3c)
select count(panr) from Passagier natural join Buchung where klasse=1

-- 3d)
select count(*) as anz from Pilot natural join Angestellt where gesell_bez='AIR FRANCE' AND quali='Chiefpilot'

-- 3e)
select count(*) as anz, quali from Pilot group by quali

-- 3f)
Wrong: select count(*) as anz, pinr From Pilot natural join Flug where 
Right: select pinr, count(*) from flug group by pinr having count(*) > 1

-- 3g)
select panr, count(*) from Buchung group by panr Having count(*) > 1 

-- Aufgabe 4
-- 4a)
select * from Flug order by start_in asc, dauer desc

-- 4b)
select distinct quali quali from Pilot order by quali

-- 4c)
select gesell_bez, name, adresse from Passagier natural join Buchung natural join Flug natural join Bestand order by gesell_bez asc, name asc

-- 4d)
select gesell_bez, avg(preis) as d_preis from Buchung natural join Flug natural join Bestand group by gesell_bez order by d_preis desc

-- Aufgabe 5
-- 5a)
select fznr, kontr From Maschine  where kontr between '19990820' and '20000121'
select fznr, kontr From Maschine  where kontr >= '1999-08-20' kontr '2000-01-21'

-- 5b)
select fznr, typ from Maschine natural join Bestand where gesell_bez = 'LUFTHANSA' and extract(year from seit) = 1999;

-- 5c)
select datediff(datum, (select * from dates where dte = current_date)) as tage from Flug where start_in = 'Bagdad' and ziel = 'Montreal'
select extract(days from (now() - datum)) AS tage from flug where start_in = 'Bagdag' and ziel = 'Montreal'

-- 5d)
select extract(year from seit) as jahr, pinr, gesell_bez from angestellt;
