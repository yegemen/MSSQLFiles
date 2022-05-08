declare @s1 int,@s2 int,@toplam int
set @s1=10 
set @s2=25
set @toplam=@s1+@s2
print('Toplam:') 
print @toplam
go

--DB da kaç tane öðrenci var?
declare @ss int 
select @ss=COUNT(*) from Ogrenci 
print('Ogrenci Sayýsý:'+CAST(@ss as varchar(10))) 

select @@SERVERNAME 

select @@SERVICENAME 
 
select @@MAX_CONNECTIONS

select * from sys.messages 

select 5/0 
select @@ERROR 

select * from sys.messages where message_id=8134 


--sorgudan etkilenen kayýt sayýsýný görmek
select * from Ogrenci
select @@ROWCOUNT

--GO ile Yýðýn Oluþturma 
declare @a int
declare @b int
set @s1=@a+@b 
print @s1 
GO 