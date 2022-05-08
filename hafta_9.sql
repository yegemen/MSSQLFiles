use okul

--SQL sorgusu
select Ogrenci.OAdi,Ogrenci.OSoyadi,Bolum.BAdi from Ogrenci,Bolum where Ogrenci.BNo=Bolum.BNo 

--view 
Create view ogr_bolum (ogr_adi,ogr_soyadi,bolum_adi)
AS  
select Ogrenci.OAdi,Ogrenci.OSoyadi,Bolum.BAdi from Ogrenci,Bolum where Ogrenci.BNo=Bolum.BNo

select * from dbo.ogr_bolum 

Create view bolum_ogrenci_say 
AS 
select Bolum.BAdi,COUNT(Ogrenci.ONo) AS 'Ogrenci Sayisi' from Bolum,Ogrenci where Bolum.BNo=Ogrenci.BNo group by Bolum.BAdi 
 
select * from dbo.bolum_ogrenci_say 
 
 insert into dbo.ogr_bolum values ('Ali','Y�lmaz','�n�aat M�hendisli�i') 

 Create view viewden_view 
 AS 
 select dbo.ogr_bolum.bolum_adi from dbo.ogr_bolum where dbo.ogr_bolum.bolum_adi='Bilgisayar M�hendisli�i' 
 
select distinct * from dbo.viewden_view 

drop view dbo.viewden_view 
 
select * from Ders 
 
select * from Puan 
 
create view puan_ders_ortalama 
AS
select Ders.DAdi,AVG(Puan.Vize) AS 'Vize Ortalamas�', AVG (Puan.Final) AS 'Final Ortalamas�' from Ders,Puan where Puan.DNo=Ders.DNo group by Ders.DAdi 
 
select * from dbo.puan_ders_ortalama 
 