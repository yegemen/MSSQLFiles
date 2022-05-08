use okul

Begin TRY
Begin
select 1/0 
End
End TRY 
Begin Catch
Begin   
select ERROR_NUMBER() AS 'Hata Kodu', 
ERROR_SEVERITY() AS 'Hata Derecesi', 
ERROR_LINE() AS 'Hata Sat�r�',  
ERROR_MESSAGE() AS 'Hata Mesaj�'  
End End Catch

--Stored Procedures 
 
sp_pkeys Bolum 
 
sp_helptext sp_pkeys 
 
sp_addlogin 'user145',1234 
 
sp_addtype sayisal, real,'null' 
 
xp_create_subdir 'C:\Tsql' 
 
xp_subdirs 'C:\' 
 
--

--Local Sp
Create Procedure ogr_liste 
AS 
Begin 
select * from Ogrenci 
End
GO
exec ogr_liste 
 
Alter Procedure ogr_liste
AS    
Begin  
select Ogrenci.OAdi,Ogrenci.OSoyadi from Ogrenci
End 
 
ogr_liste 


--Kendisine gelen B�l�m ad�na g�re bu b�l�mde ka� ��renci oldu�unu listeleyen Stored Procedure tan�mlay�n�z 
 
Create Procedure bolum_ogr_liste (@badi varchar(100)) 
AS  
Begin 
 
 select Bolum.BAdi,
 COUNT(Ogrenci.BNo) AS 'Ogrenci Say�s�' from Bolum,Ogrenci where Bolum.BNo=Ogrenci.BNo and Bolum.BAdi=@badi 
 
 End 
 
 exec bolum_ogr_liste 'Bilgisayar M�hendisli�i'


 --De�er d�nd�rme
 create procedure ortalama(@a int,@b int,@snc real output) 
 as  
 begin 
 set @snc=(@a+@b)/2   
 end    
 go 
 
   declare @snc int    execute ortalama 10,20,@snc output    print('Ortalama:'+CAST(@snc as varchar(20)))


   --ret�rn ile    
   create procedure ort(@a int, @b int) 
   as    
   begin
   return (@a+@b)/2   
   end 
 
    declare @snc int     execute @snc=ort 10,20     print (@snc)