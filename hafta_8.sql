-- Alt sorgu

use okul

-- alt sorgu olmadan öðrenciler ve bölüm adlarý

select Ogrenci.OAdi,Ogrenci.OSoyadi,Bolum.BAdi from bolum,Ogrenci where bolum.BNo=Ogrenci.BNo

-- alt sorgu ile

select s1.adi+' '+s1.soyadi as 'adi ve soyadi' ,s1.BAdi from (select Ogrenci.OAdi as adi,Ogrenci.OSoyadi as soyadi ,Bolum.BAdi from bolum,Ogrenci where bolum.BNo=Ogrenci.BNo) s1

--bölümlerdeki ortalama öðrenci sayýsýndan daha fazla öðrenci sayýsýna sahip bölümlerin isimlerini listeleyiniz.

select AVG(s1.osay) as ortogrsay from
(select Bolum.BAdi, COUNT(Ogrenci.ONo) AS osay from Ogrenci, Bolum where Ogrenci.BNo=Bolum.BNo group by bolum.BAdi) s1

--benim yaptýðým:

select Bolum.BAdi, COUNT(Ogrenci.ONo) AS osay from Ogrenci, Bolum where Ogrenci.BNo=Bolum.BNo group by bolum.BAdi having COUNT(Ogrenci.ONo)>(select AVG(s1.osay) as ortogrsay from
(select Bolum.BAdi, COUNT(Ogrenci.ONo) AS osay from Ogrenci, Bolum where Ogrenci.BNo=Bolum.BNo group by bolum.BAdi) s1
)


--hocanýn yaptýðý:

Select s1.BAdi, s1.osay  from (select Bolum.BAdi, COUNT(Ogrenci.ONo) AS osay from Ogrenci, Bolum where Ogrenci.BNo=Bolum.BNo group by bolum.BAdi) s1
where s1.osay > (select AVG(s1.osay) as ortogrsay from
(select Bolum.BAdi, COUNT(Ogrenci.ONo) AS osay from Ogrenci, Bolum where Ogrenci.BNo=Bolum.BNo group by bolum.BAdi) s1)