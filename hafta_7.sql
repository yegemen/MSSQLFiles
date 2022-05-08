Create Database okul

use okul

--bolum tablosu 
Create Table Bolum
( 
BNo int identity(1,1) Primary Key Not Null,
BAdi varchar(50) Not Null
)

--ogrenci tablosu 
Create Table Ogrenci
(
ONo int identity(1,1) Primary Key Not Null,
OAdi varchar(50) Not Null,
OSoyadi varchar(100) Not Null,
BNo int Foreign Key References Bolum(BNo)Not Null
) 

--ders tablosu
Create Table Ders
(
DNo int identity(1,1) Primary Key Not Null,
DAdi varchar(100) Not Null,
BNo int Foreign Key References Bolum(BNo)Not Null 
) 

--puan tablosu 
Create Table Puan
(
ONo int Foreign Key References Ogrenci(ONo),
DNo int Foreign Key References Ders(DNo),
Vize int Not Null CHECK(Vize>=0 and Vize<=100),
Final int Not Null CHECK(Final>=0 and Final<=100)
)

--group by

select Bolum.BAdi, COUNT(Ogrenci.ONo) AS 'Öðrenci Sayisi' from Ogrenci, Bolum where Ogrenci.BNo=Bolum.BNo group by Bolum.BAdi

select Bolum.BAdi,COUNT(Ders.DNo) AS 'Ders Sayýsý' from Bolum, Ders where Ders.BNo=Bolum.BNo group by Bolum.BAdi 

select Ders.DAdi,COUNT(Puan.ONo) AS 'Kayitli Öðrenci Sayisi:' 
from Ders,Ogrenci, Puan,Bolum 
where Ders.BNo=Bolum.BNo and Puan.ONo=Ogrenci.ONo and Ogrenci.BNo=Bolum.BNo and Ders.DNo=Puan.DNo
group by Ders.DAdi

select Ders.DAdi, AVG(Puan.Vize) AS 'Vize Ortalamasý',AVG(Puan.Final) AS 'Final Ortalamasý' 
from Ders,Puan
where Puan.DNo=Ders.DNo and Ders.BNo in(select Bolum.BNo from Bolum where  Bolum.BAdi='Bilgisayar Mühendisliði') 
group by Ders.DAdi

select Bolum.BAdi,Ders.DAdi,MIN(Puan.Vize) AS 'En Düþük Vize Notu',MAX(Puan.Vize) AS  'En Yüksek Vize Notu',MIN(Puan.Final) AS 'En Düþük Final Notu',MAX(Puan.Final) AS  'En Yüksek Final Notu' 
from Bolum,Ders,Puan 
where Puan.DNo=Ders.DNo and Bolum.BNo=Ders.BNo 
group by Bolum.BAdi,Ders.DAdi 

select Bolum.BAdi,COUNT(Ogrenci.ONo) AS 'Öðrenci Sayisi' 
from Ogrenci,Bolum 
where Ogrenci.BNo=Bolum.BNo 
group by Bolum.BAdi 
having (COUNT(Ogrenci.ONo)>=3)

---

--birden fazla tablo ile sorgulama

--1 where ile

select Ogrenci.OAdi,Ogrenci.OSoyadi,Bolum.BAdi from Ogrenci,Bolum where Bolum.BNo=Ogrenci.BNo


--2 inner join 
 
select Ogrenci.OAdi,Ogrenci.OSoyadi,Bolum.BAdi from Ogrenci inner join Bolum on Bolum.BNo=Ogrenci.BNo 
 
select * from Ogrenci inner join Bolum on Ogrenci.BNo=Bolum.BNo and BAdi='Bilgisayar Mühendisliði' and Ogrenci.ONo not in (select Puan.ONo from Puan where Puan.DNo in(select Ders.DNo from Ders where Ders.DAdi='Algoritma'))


--3 iç içe sorgulama 
 
select Ogrenci.OAdi,Ogrenci.OSoyadi from Ogrenci where BNo IN (select BNo from Bolum where BAdi='Bilgisayar Mühendisliði')

--Takma isim kullanma

Select ogr.OAdi,ogr.OSoyadi,b.BAdi from Bolum b, Ogrenci ogr where ogr.BNo=b.BNo