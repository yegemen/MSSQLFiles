--Tablo tipi deðiþkenler 

use okul

declare @ogr TABLE
(  
no int, 
adi varchar(30), 
soyadi varchar(30)
) 
insert into @ogr values (1,'Ali','Gül') 
select * from @ogr

--Örnek 2 
declare @ogr_liste TABLE(
ono int 
) 
insert into @ogr_liste values (1) 
insert into @ogr_liste values (3) 
select * from Ogrenci where ONo IN (select ono from @ogr_liste) 
GO 

--insert output 
select * from Ogrenci 
declare @ogr TABLE(
oadi varchar(50),
osadi varchar(50),
bno int
)
insert into Ogrenci
OUTPUT
inserted.OAdi,inserted.OSoyadi,inserted.BNo
INTO @ogr
values ('Cenk','Yel',1) 
select * from @ogr
GO 

--delete output
declare @ogr_sil TABLE(
ono int,
oadi varchar(50),
osadi varchar(50),
bno int
)
delete from Ogrenci
OUTPUT
deleted.ONO,deleted.OAdi,deleted.OSoyadi,deleted.BNo INTO @ogr_sil 
where Ogrenci.ONo=4 
select * from @ogr_sil


--update output 
declare @bolum_guncelle TABLE(
bno int,
badi_eski varchar(30),
badi_yeni varchar(30)
)
update Bolum set Bolum.BAdi='Kimya ve Süreç Mühendisliði'
OUTPUT 
inserted.BNo,inserted.BAdi,deleted.BAdi
INTO @bolum_guncelle
 where Bolum.BNo=3  
 select * from @bolum_guncelle


 --WHILE 
 declare @sayi varchar(10),@sayac int,@r_top int,@cpy varchar(10), @bs varchar(5)
 set @sayi='35464616' 
 set @sayac=1 
 set @r_top=0 
 select @bs=LEN(@sayi)
 while(@sayac<=CAST(@bs as int))
	Begin    
	 select @cpy=SUBSTRING(@sayi,@sayac,1) 
	 set @r_top+=CAST( @cpy as int)
	 set @sayac=@sayac+1  
	End  
	if(@r_top%3=0) 
	 Begin     
		print('Rakamlari toplami:'+CAST(@r_top as varchar(10)))
		print('Bolunur')
	 End 
	else 
	 Begin    
     print('Rakamlari toplami:'+CAST(@r_top as varchar(10)))
	 print('Bolunmez') 
	End
 GO 