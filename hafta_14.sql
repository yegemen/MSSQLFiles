Create Database Eticaret 
 
use Eticaret 
 
--Tablo Oluþturma

Create Table Musteri(
MNo int Primary Key identity(1,1),
MAdi varchar(20),
MSoyad varchar(20)
) 

Create Table Urun(
Uno int primary key,
UAdi varchar(50),
UMiktar int
)

Create Table Alim( 
UNo int Foreign Key References Urun(UNo),
MNo int Foreign Key References Musteri(MNo),
AlMik int, 
AlTrh datetime 
) 

Create Table Satis(
UNo int Foreign Key References Urun(UNo), 
MNo int Foreign Key References Musteri(MNo),
SMik int, 
STrh datetime 
)

select * from Urun 
 
--Insert trigger
Create Trigger ekle 
ON Alim 
FOR INSERT
AS   
Begin    
declare @uno int,@almik int 
select @uno=UNo,@almik=AlMik from inserted 
update Urun set UMiktar=UMiktar+@almik where UNo=@uno  
End
GO 
select * from Urun 
select * from Alim 
insert into Alim values(1,1,10,'') 
 
Create Trigger ekle2 
ON Satis
FOR INSERT 
AS  
Begin   
declare @uno int, @smik int
select @uno=UNo,@smik=SMik from inserted  
update Urun set UMiktar=UMiktar-@smik where UNo=@uno 
End
GO 
select * from Urun 
select * from Satis
insert into Satis values(1,1,5,'') 

--Delete trigger 
Create Trigger silme
ON Urun
FOR DELETE
AS
Begin
declare  @uno int
select @uno=UNo from deleted
delete from Satis where UNo=@uno
delete from Alim where UNo=@uno
End
GO
delete from Urun where UNo=3

--Update tigger
Create Trigger guncelleme
ON Alim
FOR UPDATE
AS
Begin
declare @uno int,@emik int,@ymik int, @fark int
select @uno=UNo,@emik=AlMik from deleted 
select @ymik=AlMik from inserted   
set @fark=@ymik-@emik 
update Urun set UMiktar=UMiktar+@fark where UNo=@uno
End 
GO 
select * from Urun 
select * from Alim 
insert into Alim values(4,1,4,'') 
update Alim set AlMik=3 where UNo=4