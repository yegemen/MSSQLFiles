use OtoGaleri

select * from musteri
update musteri set Madres='Bilecik' where MNo=6

--distinct
select distinct MAdres AS 'Musterinin Adresi' from musteri --text i varchar a dönüþtüremediðinden yazamadý.

select * from musteri order by MAdi desc

select * from musteri where MNo between 0 and 6

select * from musteri where MAdi like ('_A__')

--fonksiyonlar

select SUBSTRING(musteri.MAdi,1,2) AS 'ilk iki' from musteri

select left(musteri.MAdi,3) from musteri

select right(musteri.MAdi,3) from musteri

select lower(MAdi) as 'büyük' , upper(MAdi) as 'küçük' from musteri

select len(musteri.MAdi) as 'uzunluk' from musteri 

select musteri.MAdi, replace(musteri.MAdi, 'Lale', 'Oya') AS 'degistirme' from musteri

select musteri.MAdi, reverse(musteri.MAdi) As 'Tersten' from musteri

select abs(-10) as 'mutlak deger'

select floor(3.5646) as ' '

select sum(satis.Stfiyat) as 'toplam satis fiyati' from satis 

select avg(satis.Stfiyat) as 'ortalama satis fiyati' from satis 

select max(satis.Stfiyat) as 'eny satis fiyati' from satis 

select min(satis.Stfiyat) as 'enk satis fiyati' from satis 

select count(*) as 'kayit sayisi' from satis

select getdate() 'tarih ve saat'

select datepart(year,getdate()) as 'yil'