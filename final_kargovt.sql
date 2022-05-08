create database kargovt

use kargovt

create table ulke
(
UlkeNo int primary key identity(1,1),
UlkeAdi varchar(30) NOT NULL,
)

create table il
(
ilNo int primary key identity(1,1),
ilAdi varchar(30) NOT NULL,
UlkeNo int foreign key references ulke(UlkeNo) NOT NULL
)

create table musteri
(
musNo int primary key identity(1,1),
musAdi varchar(30) NOT NULL,
musSoyadi varchar(30) NOT NULL,
UlkeNo int foreign key references ulke(UlkeNo) NOT NULL,
ilNo int foreign key references il(ilNo) NOT NULL
)

create table UlasimYolu
(
UlsmNo int primary key identity(1,1),
UlsmYol varchar(30) NOT NULL,
CONSTRAINT chkUlsmNo CHECK (UlsmNo<=3) -- 3 tip ulasim yolu olsun. daha fazla kayit girilmesin
)

create table Tedarikci
(
FirmaNo int primary key identity(1,1),
FirmaAdi varchar(30) NOT NULL,
UlkeNo int foreign key references ulke(UlkeNo) NOT NULL,
ilNo int foreign key references il(ilNo) NOT NULL
)

create table urunKategori
(
ktgNo int primary key identity(1,1),
ktgAdi varchar(30) NOT NULL,
)

create table urun
(
urunNo int primary key identity(1,1),
urunAdi varchar(30) NOT NULL,
stokSay int NOT NULL,
urunUcret money NOT NULL,
ktgNo int foreign key references urunKategori(ktgNo) NOT NULL,
FirmaNo int foreign key references Tedarikci(FirmaNo) NOT NULL
)

create table siparis
(
sipNo int primary key identity(1,1),
sipTarih date NOT NULL,
sipMiktar int NOT NULL,
musNo int foreign key references musteri(musNo) NOT NULL,
ktgNo int foreign key references urunKategori(ktgNo) NOT NULL,
urunNo int foreign key references urun(urunNo) NOT NULL,
FirmaNo int foreign key references Tedarikci(FirmaNo) NOT NULL,
UlsmNo int foreign key references UlasimYolu(UlsmNo) NOT NULL
)

create table siparisIade
(
iadeNo int primary key identity(1,1),
iadeTarih date NOT NULL,
iadeMiktar int NOT NULL,
sipNo int foreign key references siparis(sipNo) NOT NULL,
musNo int foreign key references musteri(musNo) NOT NULL,
ktgNo int foreign key references urunKategori(ktgNo) NOT NULL,
urunNo int foreign key references urun(urunNo) NOT NULL,
FirmaNo int foreign key references Tedarikci(FirmaNo) NOT NULL,
UlsmNo int foreign key references UlasimYolu(UlsmNo) NOT NULL
)

create table teslimatBilgi
(
tslmtNo int primary key identity(1,1),
tslmTarih date NOT NULL,
tslmUcret money NOT NULL,
UlsmNo int foreign key references UlasimYolu(UlsmNo) NOT NULL,
sipNo int foreign key references siparis(sipNo) NOT NULL,
musNo int foreign key references musteri(musNo) NOT NULL,
ktgNo int foreign key references  UrunKategori(ktgNo) NOT NULL,
)


--2. Bugüne kadar en fazla sipariþ verilen tedarikçi firma için, bu tedarikçiden en fazla sipariþ veren müþterinin ad, soyad, ülke, toplamda taþýmaya ne kadar ücret ödediði ve kaç tane hangi kategoriden sipariþ verdiðinin bilgisini listeleyecek SQL sorgusunu yazýnýz.

SELECT mst.musAdi as 'Musteri Adi', mst.musSoyadi as 'Musteri Soyadi', u.UlkeAdi as 'Ulke Adi', tb.tslmUcret as 'Ucret', ukt.ktgAdi as 'Kategori Adi', sipktg.sipMiktar as 'Siparis Sayisi'
FROM musteri mst, ulke u, teslimatBilgi tb, urunKategori ukt, (SELECT uk.ktgNo, COUNT(sip.sipNo) as sipMiktar FROM urunKategori uk, siparis sip
where uk.ktgNo=sip.ktgNo
group by uk.ktgNo) sipktg
where mst.UlkeNo=u.UlkeNo and mst.musNo=tb.musNo and tb.ktgNo=ukt.ktgNo and ukt.ktgNo=sipktg.ktgNo
and mst.musNo = (select m.musNo, MAX(SUM(s.sipMiktar)) FROM musteri m, siparis s
where m.musNo=s.sipNo and FirmaNo=(SELECT td.FirmaNo, MAX(SUM(sp.sipMiktar)) FROM Tedarikci td, siparis sp
where td.FirmaNo=sp.sipNo group by td.FirmaNo)
group by m.musNo)


--3. Kendisine gelen tedarikçi ismine göre, bu tedarikçiden hiçbir sipariþ vermeyen ve fakat baþka tedarikçilerden sipariþ veren müþterilerin ve ilgili sipariþteki bilgileri ekrana listeleyecek bir stored procedure yazýnýz ve kullanýnýz. 

CREATE PROCEDURE tedarikci_ismi (@firma_adi varchar(50))
AS
	BEGIN

	SELECT m.musAdi as 'Musteri Adi', u.urunAdi as 'Urun Adi', u.urunUcret as 'Urun Ucreti', s.sipMiktar as 'Siparis Miktar', s.sipTarih as 'Siparis Tarih' FROM musteri m, siparis s, urun u, tedarikci t
	where m.musNo=s.musNo and s.urunNo=u.urunNo and s.FirmaNo=t.FirmaNo
	and t.FirmaNo in (SELECT td.FirmaNo FROM Tedarikci td where td.FirmaAdi <> @firma_adi)

	END

	exec tedarikci_ismi 'amazon'

	--veya:

	CREATE PROCEDURE tedarikci_ismi_deneme (@firma_adi varchar(50))
AS
	BEGIN

	SELECT m.musAdi as 'Musteri Adi', u.urunAdi as 'Urun Adi', u.urunUcret as 'Urun Ucreti', s.sipMiktar as 'Siparis Miktar', s.sipTarih as 'Siparis Tarih' FROM musteri m, siparis s, urun u, tedarikci t
	where m.musNo=s.musNo and s.urunNo=u.urunNo and s.FirmaNo=t.FirmaNo
	and t.FirmaAdi <> @firma_adi

	END

	exec tedarikci_ismi_deneme 'amazon'


--4. Tüm taþýma iþlemleri içerisinde bulunan ortalama ürün sayýsýndan daha fazla ürün sipariþi veren müþterilerden hangilerinin en az sayýda sipariþ verdiði ürün kategorisini ve sipariþ ettiði ürün sayýsýný listeleyecek bir fonksiyon ve kullanýnýz.

Create Function Listele()
RETURNS Table 
AS 
return
(
SELECT urk.ktgAdi, ur.urunAdi, COUNT(sp.sipNo) FROM musteri must, siparis sp, urun ur, urunKategori urk
where must.musNo=sp.musNo and sp.urunNo=ur.urunNo and ur.ktgNo=urk.ktgNo
and must.musNo in (SELECT mst.musNo, MIN(sprs.sipMiktar) FROM musteri mst, siparis sprs
where mst.musNo=sprs.sipNo and mst.musNo in (SELECT mus.musNo, SUM(sip.sipMiktar) FROM musteri mus, siparis sip
where mus.musNo=sip.sipNo group by mus.musNo HAVING SUM(sip.sipMiktar) > (SELECT AVG(s1.miktar) FROM (SELECT u.urunAdi, SUM(s.sipMiktar) as miktar FROM siparis s, urun u
where u.urunNo=s.urunNo
group by u.urunAdi) s1)) 
group by mst.musNo)
group by urk.ktgAdi, ur.urunAdi
) 
GO 

listele()


--5. Sipariþ edilen bir ürünün müþteri tarafýndan miktarý deðiþtirildiðinde bunun direkt olarak ürünün stok sayýsýna yansýmasý sýrasýnda önceki ve yeni bilgileri kullanýcýya gösterecek bir output yazýnýz. 

declare @urnNo int, @eskiMiktar int, @yeniMiktar int
set @eskiMiktar=10
set @yeniMiktar=20
set @urnNo=1

declare @urun TABLE(
uNo int,
uAdi varchar(30),
eStok int,
yStok int
)
update urun set stokSay=stokSay + @eskiMiktar - @yeniMiktar -- onceki miktari tekrar ekleyip yeni miktari cikarttim.
OUTPUT
inserted.urunNo,inserted.urunAdi,deleted.stokSay,inserted.stokSay INTO @urun
	where urunNo = (select urunNo from siparis where urunNo=@urnNo)
SELECT * FROM @urun
go


--6. Gönderilecek ürünün miktarýnda yapýlan güncelleme sonrasýnda sipariþ ile ilgili gerekli düzenlemeleri yapan bir trigger yazýnýz. 

CREATE TRIGGER guncelDuzenleme
ON siparis
FOR update
AS
	BEGIN
	declare @urunmiktari int
	select @urunmiktari=sipMiktar from inserted
	update siparis set sipMiktar=@urunmiktari
	END
go


--7. Müþteri web sitesine kayýt olurken eðer müþteri daha önceden kayýtlýysa, kaydýnýn bulunduðu uyarýsýný veren, þayet ilk defa geliyorsa bu müþterinin kayýt iþlemini yapan bir trigger yazýnýz. 

CREATE TRIGGER musteriEkleme
ON musteri
FOR insert
AS
	BEGIN
	declare @musno int, @musadi varchar(30), @mussoyadi varchar(30), @ulkeno int, @ilno int
	select @musno=musNo, @musadi=musAdi, @mussoyadi=musSoyadi, @ulkeno=UlkeNo, @ilno=ilNo from inserted
		IF EXISTS(SELECT * FROM musteri where musNo=@musno and musAdi=@musadi and musSoyadi=@mussoyadi and UlkeNo=@ulkeno and ilNo=@ilno)
		BEGIN
			PRINT ('Bu musterinin kaydi zaten var !')
		END
		
		ELSE
		BEGIN
			insert into musteri values(@musno,@musadi,@mussoyadi,@ulkeno,@ilno)
		END
	END
go


--8. Sipariþ ettiði ürünlerden, en fazla geri iade eden ilk üç müþterinin ID, ad, soyad ve kaç tane sipariþ verdiði ve kaç tanesini geri iade ettiðini geriye döndürecek bir fonksiyon yazýnýz. 

Create Function bilgiGoster()
RETURNS @bilgi TABLE(
	musid int,
	musad varchar(30),
	mussoyad varchar(30),
	siparisMiktar int,
	iadeMiktar int
	)
AS 
BEGIN

declare @sayac int
set @sayac=1

while(@sayac<=3)
BEGIN

insert into @bilgi (musid,musad,mussoyad,siparisMiktar,iadeMiktar)

SELECT ms.musNo, ms.musAdi, ms.musSoyadi, muss.siparissayi, mus.iadesayi FROM musteri ms, (SELECT m.musNo, SUM(spi.iadeMiktar) as iadesayi FROM siparisIade spi, musteri m
where m.musNo=spi.musNo group by m.musNo order by spi.iadeMiktar desc) mus, (SELECT mstr.musNo, SUM(sip.sipMiktar) as siparissayi FROM musteri mstr, siparis sip
where mstr.musNo=sip.musNo group by mstr.musNo) muss
where ms.musNo=mus.musNo and ms.musNo=muss.musNo order by iadesayi desc
set @sayac=@sayac+1

END

RETURN
END
GO 


--9. Bulunduðu ülke dýþýndan sipariþ veren müþterilerden her birisinin kargosunun/yükünün hangi yolla taþýndýðýný, ne kadar ücret ödendiðini, teslimatýn kaç gün sürdüðünü ve sipariþin içeriðini listeleyecek bir stored procedure yazýnýz.

CREATE PROCEDURE YurtDisiSiparis
AS
	BEGIN

	SELECT t2.UlsmYol AS 'Ulasim Yolu', t2.tslmUcret AS 'Ucret', DATEDIFF(day,sip.sipTarih,t2.tslmTarih) AS 'Gecen Gun Sayisi', urun.urunAdi AS 'Urun Adi', sip.sipMiktar AS 'Urun Miktari' FROM musteri ms, siparis sip, urun, (SELECT mus.musNo, uy.UlsmYol, tsb.tslmUcret, tsb.tslmTarih FROM musteri mus, teslimatBilgi tsb, UlasimYolu uy where mus.musNo=tsb.musNo and tsb.UlsmNo=uy.UlsmNo) t2
where ms.musNo=t2.musNo and ms.musNo in (SELECT m.musNo FROM musteri m, siparis s
where m.musNo=s.musNo and m.musNo in (SELECT ms.musNo FROM musteri ms, siparis sp, Tedarikci td where ms.musNo=sp.sipNo and sp.FirmaNo=td.FirmaNo and ms.UlkeNo <> td.UlkeNo))

	END
	go

exec YurtDisiSiparis


--10. Bugüne kadar 10’dan fazla sipariþ veren her bir müþterinin en fazla sipariþ verdiði ürün kategorilerinin hangilerinin denizyolu ile taþýndýðýnýn bilgilerini listeleyecek bir fonksiyon yazýnýz. 

Create Function denizTasima()
RETURNS Table 
AS 
return
(
SELECT urk.ktgAdi 'Kategori Adi', MAX(sp.sipMiktar) FROM musteri ms, siparis sp, urunKategori urk, ulasimYolu uy, (SELECT m.musNo, COUNT(s.sipNo) as SiparisSayi FROM musteri m, siparis s where m.musNo=s.musNo group by m.musNo HAVING COUNT(s.sipNo)>10) s1 where ms.musNo=sp.sipNo and sp.ktgNo=urk.ktgNo and ms.musNo=s1.musNo and sp.UlsmNo=uy.UlsmNo and uy.UlsmNo in (select UlsmNo from UlasimYolu where UlsmYol='deniz')
group by urk.ktgAdi
) 
GO