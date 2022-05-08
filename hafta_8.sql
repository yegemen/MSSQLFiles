-- Alt sorgu

use okul

-- alt sorgu olmadan ��renciler ve b�l�m adlar�

select Ogrenci.OAdi,Ogrenci.OSoyadi,Bolum.BAdi from bolum,Ogrenci where bolum.BNo=Ogrenci.BNo

-- alt sorgu ile

select s1.adi+' '+s1.soyadi as 'adi ve soyadi' ,s1.BAdi from (select Ogrenci.OAdi as adi,Ogrenci.OSoyadi as soyadi ,Bolum.BAdi from bolum,Ogrenci where bolum.BNo=Ogrenci.BNo) s1

--b�l�mlerdeki ortalama ��renci say�s�ndan daha fazla ��renci say�s�na sahip b�l�mlerin isimlerini listeleyiniz.

select AVG(s1.osay) as ortogrsay from
(select Bolum.BAdi, COUNT(Ogrenci.ONo) AS osay from Ogrenci, Bolum where Ogrenci.BNo=Bolum.BNo group by bolum.BAdi) s1

--benim yapt���m:

select Bolum.BAdi, COUNT(Ogrenci.ONo) AS osay from Ogrenci, Bolum where Ogrenci.BNo=Bolum.BNo group by bolum.BAdi having COUNT(Ogrenci.ONo)>(select AVG(s1.osay) as ortogrsay from
(select Bolum.BAdi, COUNT(Ogrenci.ONo) AS osay from Ogrenci, Bolum where Ogrenci.BNo=Bolum.BNo group by bolum.BAdi) s1
)


--hocan�n yapt���:

Select s1.BAdi, s1.osay  from (select Bolum.BAdi, COUNT(Ogrenci.ONo) AS osay from Ogrenci, Bolum where Ogrenci.BNo=Bolum.BNo group by bolum.BAdi) s1
where s1.osay > (select AVG(s1.osay) as ortogrsay from
(select Bolum.BAdi, COUNT(Ogrenci.ONo) AS osay from Ogrenci, Bolum where Ogrenci.BNo=Bolum.BNo group by bolum.BAdi) s1)