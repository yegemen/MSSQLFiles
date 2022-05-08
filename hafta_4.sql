use OtoGaleri

select * from  musteri

insert into musteri (MAdi, MSoyadi, Madres) values ('Ali', 'Yel', 'Bilecik')

update musteri set MTel='1236+' where MNo=1

insert into Musteri values ('Mehmet','Cem','Ankara','3546784')

select Musteri.MAdi, Musteri.MSoyadi from Musteri

select * from musteri where MAdi LIKE ('A%')

delete from Musteri where Madi LIKE ('%A%')
select * from Musteri

insert into Musteri values ('Lale', 'Gulmez', 'Ankara', '6454554')