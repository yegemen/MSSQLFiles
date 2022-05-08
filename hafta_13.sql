use okul 
 
--Functions 
 
--Kendisine gelend b�l�m numaras�na g�re bu b�l�mde ka� ��renci oldu�unu egriye d�nd�ren bir fonksiyon yaz�n�z
--Scalar-valued functions

Create Function bolum_ogrenci(@bno int)
RETURNS int 
AS  
Begin  
declare @os int 
select @os=COUNT(Ogrenci.ONo) from Ogrenci where BNo IN (select BNo from Bolum where BNo=@bno) 
return @os   
End
GO 

select dbo.bolum_ogrenci(1) 


--Kendisine gelen ��renci numaras�na g�re bu ��rencinin ad�n� ve soyad�n� ve her bir dersten ald��� vize ve final notlar�n� geriye d�nd�ren bir fonksiyon yaz�n�z 
--Table-valued functions 
 
Create Function ogrenci_not(@ono int)
RETURNS Table 
AS 
return(
select Ogrenci.OAdi,Ogrenci.OSoyadi,Bolum.BAdi,Ders.DAdi,Puan.Vize,Puan.Final from Ogrenci,Bolum,Ders,Puan where Ogrenci.BNo=Bolum.BNo and Ders.BNo=Bolum.BNo and Ogrenci.ONo=Puan.ONo and Puan.DNo=Ders.DNo and Ogrenci.ONo=@ono
) 
GO 
select * from dbo.ogrenci_not(1)

--Kendisine gelen b�l�m numaras�na g�re bu b�l�m�n ad�n�, ka� ��renci oldu�unu ve ka� ders oldu�unu geriye d�nd�ren bir fonksiyon yaz�n�z  
--Aggregate functions 
 
 Create Function bolum_ders_ogrenci(@bno int) 
 RETURNS  @liste TABLE( 
 badi varchar(50), 
 osay int,     
 dsay int        
 ) 
 AS
 Begin     
 insert into @liste (badi,osay,dsay) select Bolum.BAdi, (select COUNT(Ogrenci.ONo) from Ogrenci where BNO IN (select BNO from Bolum where BNo=@bno)), (select COUNT(Ders.DNo) from Ders where BNo IN (select BNo from Bolum where BNo=@bno))  from Bolum where BNo=@bno   
 Return 
 End 
 GO  
 select * from dbo.bolum_ders_ogrenci(1)