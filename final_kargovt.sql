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


--2. Bug�ne kadar en fazla sipari� verilen tedarik�i firma i�in, bu tedarik�iden en fazla sipari� veren m��terinin ad, soyad, �lke, toplamda ta��maya ne kadar �cret �dedi�i ve ka� tane hangi kategoriden sipari� verdi�inin bilgisini listeleyecek SQL sorgusunu yaz�n�z.

SELECT mst.musAdi as 'Musteri Adi', mst.musSoyadi as 'Musteri Soyadi', u.UlkeAdi as 'Ulke Adi', tb.tslmUcret as 'Ucret', ukt.ktgAdi as 'Kategori Adi', sipktg.sipMiktar as 'Siparis Sayisi'
FROM musteri mst, ulke u, teslimatBilgi tb, urunKategori ukt, (SELECT uk.ktgNo, COUNT(sip.sipNo) as sipMiktar FROM urunKategori uk, siparis sip
where uk.ktgNo=sip.ktgNo
group by uk.ktgNo) sipktg
where mst.UlkeNo=u.UlkeNo and mst.musNo=tb.musNo and tb.ktgNo=ukt.ktgNo and ukt.ktgNo=sipktg.ktgNo
and mst.musNo = (select m.musNo, MAX(SUM(s.sipMiktar)) FROM musteri m, siparis s
where m.musNo=s.sipNo and FirmaNo=(SELECT td.FirmaNo, MAX(SUM(sp.sipMiktar)) FROM Tedarikci td, siparis sp
where td.FirmaNo=sp.sipNo group by td.FirmaNo)
group by m.musNo)


--3. Kendisine gelen tedarik�i ismine g�re, bu tedarik�iden hi�bir sipari� vermeyen ve fakat ba�ka tedarik�ilerden sipari� veren m��terilerin ve ilgili sipari�teki bilgileri ekrana listeleyecek bir stored procedure yaz�n�z ve kullan�n�z. 

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


--4. T�m ta��ma i�lemleri i�erisinde bulunan ortalama �r�n say�s�ndan daha fazla �r�n sipari�i veren m��terilerden hangilerinin en az say�da sipari� verdi�i �r�n kategorisini ve sipari� etti�i �r�n say�s�n� listeleyecek bir fonksiyon ve kullan�n�z.

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


--5. Sipari� edilen bir �r�n�n m��teri taraf�ndan miktar� de�i�tirildi�inde bunun direkt olarak �r�n�n stok say�s�na yans�mas� s�ras�nda �nceki ve yeni bilgileri kullan�c�ya g�sterecek bir output yaz�n�z. 

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


--6. G�nderilecek �r�n�n miktar�nda yap�lan g�ncelleme sonras�nda sipari� ile ilgili gerekli d�zenlemeleri yapan bir trigger yaz�n�z. 

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


--7. M��teri web sitesine kay�t olurken e�er m��teri daha �nceden kay�tl�ysa, kayd�n�n bulundu�u uyar�s�n� veren, �ayet ilk defa geliyorsa bu m��terinin kay�t i�lemini yapan bir trigger yaz�n�z. 

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


--8. Sipari� etti�i �r�nlerden, en fazla geri iade eden ilk �� m��terinin ID, ad, soyad ve ka� tane sipari� verdi�i ve ka� tanesini geri iade etti�ini geriye d�nd�recek bir fonksiyon yaz�n�z. 

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


--9. Bulundu�u �lke d���ndan sipari� veren m��terilerden her birisinin kargosunun/y�k�n�n hangi yolla ta��nd���n�, ne kadar �cret �dendi�ini, teslimat�n ka� g�n s�rd���n� ve sipari�in i�eri�ini listeleyecek bir stored procedure yaz�n�z.

CREATE PROCEDURE YurtDisiSiparis
AS
	BEGIN

	SELECT t2.UlsmYol AS 'Ulasim Yolu', t2.tslmUcret AS 'Ucret', DATEDIFF(day,sip.sipTarih,t2.tslmTarih) AS 'Gecen Gun Sayisi', urun.urunAdi AS 'Urun Adi', sip.sipMiktar AS 'Urun Miktari' FROM musteri ms, siparis sip, urun, (SELECT mus.musNo, uy.UlsmYol, tsb.tslmUcret, tsb.tslmTarih FROM musteri mus, teslimatBilgi tsb, UlasimYolu uy where mus.musNo=tsb.musNo and tsb.UlsmNo=uy.UlsmNo) t2
where ms.musNo=t2.musNo and ms.musNo in (SELECT m.musNo FROM musteri m, siparis s
where m.musNo=s.musNo and m.musNo in (SELECT ms.musNo FROM musteri ms, siparis sp, Tedarikci td where ms.musNo=sp.sipNo and sp.FirmaNo=td.FirmaNo and ms.UlkeNo <> td.UlkeNo))

	END
	go

exec YurtDisiSiparis


--10. Bug�ne kadar 10�dan fazla sipari� veren her bir m��terinin en fazla sipari� verdi�i �r�n kategorilerinin hangilerinin denizyolu ile ta��nd���n�n bilgilerini listeleyecek bir fonksiyon yaz�n�z. 

Create Function denizTasima()
RETURNS Table 
AS 
return
(
SELECT urk.ktgAdi 'Kategori Adi', MAX(sp.sipMiktar) FROM musteri ms, siparis sp, urunKategori urk, ulasimYolu uy, (SELECT m.musNo, COUNT(s.sipNo) as SiparisSayi FROM musteri m, siparis s where m.musNo=s.musNo group by m.musNo HAVING COUNT(s.sipNo)>10) s1 where ms.musNo=sp.sipNo and sp.ktgNo=urk.ktgNo and ms.musNo=s1.musNo and sp.UlsmNo=uy.UlsmNo and uy.UlsmNo in (select UlsmNo from UlasimYolu where UlsmYol='deniz')
group by urk.ktgAdi
) 
GO