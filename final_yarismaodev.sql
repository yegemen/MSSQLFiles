create database yarismasite
use yarismasite

create table il
(
ilNo int primary key NOT NULL,
ilAdi varchar(20) NOT NULL,
CONSTRAINT chkilNo CHECK (ilNo>=1 AND ilNo <=81)
)

create table uyelik
(
Uno int primary key identity(1,1),
Uadi varchar(20) NOT NULL,
Usoyadi varchar(20) NOT NULL,
KatilimTrh date NOT NULL,
ilNo int foreign key references il(ilNo) NOT NULL
)

create table soruZorluk
(
SzId int primary key identity(1,1),
SzPuan int NOT NULL,  --ayný zorluktaki sorularin puanlari ayni olacagi icin.
SzAdi varchar (20) NOT NULL  --kolay, orta, zor vb bilgileri tutulacak.
)

create table soruKategori
(
KtgId int primary key identity(1,1),
KtgAdi varchar(20) default('diger') NOT NULL, --tarih, spor, kultur vb bilgileri tutulacak.
)

create table soruGonder
(
Sno int primary key identity(1,1),
Soru varchar(300) NOT NULL,
cvp_a varchar(50) NOT NULL,
cvp_b varchar(50) NOT NULL,
cvp_c varchar(50) NOT NULL,
cvp_d varchar(50) NOT NULL,
dogru_cvp varchar(50) NOT NULL,
GndTarih date,
Uno int foreign key references uyelik(Uno) NOT NULL,
SzId int foreign key references soruZorluk(SzId) NOT NULL, --daha sonra tablo birleþtirme islemi ile zorluk ve puanlarini gosterebiliriz.
KtgId int foreign key references soruKategori(KtgId) NOT NULL
)

create table kurulOnay
(
KrlId int primary key identity(1,1),
Krl1 bit NOT NULL, --0 ise onaylanmadi, 1 ise onaylandi. alttaki 2 sutun icinde ayni sekilde.
Krl2 bit NOT NULL,
Krl3 bit NOT NULL,
OnayTrh date NOT NULL,
Sno int foreign key references soruGonder(Sno) NOT NULL
)

create table joker
(
jkrId int primary key identity(1,1),
jkrAdi varchar(25) NOT NULL,
)

create table uyeYaris  -- uye yarisa girince 20 soru sorulacak
(
YrsId int primary key identity(1,1),
TplmPuan int NOT NULL, -- girdiði yarýþtaki toplam puaný
dogruSay int NOT NULL,
yanlisSay int NOT NULL,
YrsTarih date NOT NULL,
Uno int foreign key references uyelik(Uno) NOT NULL,
KtgId int foreign key references soruKategori(KtgId) NOT NULL, --uye bir kategori secip o sekilde yarisacagi icin.
jkrId int foreign key references joker(jkrId) NULL --boþ býrakýlýrsa üye joker kullanmamýþtýr.
)

create table istatistik
(
istNo int primary key identity(1,1),
UyePuan int NOT NULL,
GndSoruSayi int NOT NULL,
YarisSayi int NOT NULL,
Uno int foreign key references uyelik(Uno) NOT NULL
)

create table arkadasYaris
(
arkId int primary key identity(1,1),
Uno int foreign key references uyelik(Uno) NOT NULL
)

create table hediye
(
hdyId int primary key identity(1,1),
hdyAdi varchar(25) NOT NULL,
istNo int foreign key references istatistik(istNo) NOT NULL --hediye verilecek uyeleri belirlemek icin
)

-- asagida yarisma harici tablolar var.

--

/*
asagida siteYonetim tablosu var. site yoneticilerinin bilgileri bu tabloda tutulacak. yntcGorev ve yntcil sutunlari diger 2 tablo ile iliskilidir. Normalizasyon a uymasi icin diger 2 tabloyu olusturup iliskilendirdim, yanlarýnda da açýkladým.
*/

create table yonetimGorev --gorev bilgileri bu tabloda tutulur.
(
GrvNo int primary key identity(1,1),
GrvAdi varchar(50)
)

create table siteYonetim --ana tablo bu, yukardaki 1 tablo ve asagidaki 1 tablo iliskilidir.
(
yntcNo int primary key identity(1,1),
yntcAdi varchar(20) NOT NULL,
yntcSoyadi varchar(20) NOT NULL
)

create table YoneticiGorev --bir yönetici birden fazla görevi yapabileceði için bu tabloyu oluþturdum.
(
yntcNo int foreign key references siteYonetim(yntcNo) NOT NULL,
GrvNo int foreign key references yonetimGorev(GrvNo) NOT NULL
)

--

/*
asagida KurulBilgi tablosu var. Kurul üyelerinin bilgileri bu tabloda tutulacak, diðer 2 tabloda ana tablo ile ilgili tutulan bilgiler var. yanlarýnda da açýkladým. oluþturulma sýralarýnýn farklý olmasý iliþkilendirmede sorun yaþanmamasý içindir.
*/

create table kurulMeslek --meslek bilgilerini tutmak için
(
Mno int primary key identity(1,1),
MesAdi varchar(25)
)

create table kurulIl --il bilgilerini tutmak için
(
ilNo int primary key identity(1,1),
ilAdi varchar(20) NOT NULL
)

create table KurulBilgi --ana tablo bu, yukaridaki  meslek ve il tablolari ile iliskilidir.
(
KrlId int primary key identity(1,1),
KrlAdi varchar(20) NOT NULL,
KrlSoyadi varchar(20) NOT NULL,
mesNo int foreign key references kurulMeslek(Mno) NOT NULL,
ilNo int foreign key references kurulIl(ilNo) NOT NULL
)


--

/*
aþaðýda sosyalGorev tablosu var, hangi sosyal medya sorumlularýnýn hangi sosyal medya hesaplarý ile ilgileneceðinin bilgilerini tutmak için oluþturdum. yanlarýnda da açýkladým. oluþturulma sýralarýnýn farklý olmasý iliþkilendirmede sorun yaþanmamasý içindir.
*/

create table siteSosyalMedya -- sitenin hangi sosyal medya hesaplarý oldugu.
(
SmId int primary key identity(1,1),
SmAd varchar(20) NOT NULL,
)

create table sosyalSorumlular --sosyal medya hesaplari ile ilgilenecek kisiler
(
SSId int primary key identity(1,1),
SSad varchar(20) NOT NULL,
SSsoyad varchar(20) NOT NULL
)

create table sosyalGorev -- bir sorumlu birden fazla hesap ile ilgilenebilir, bir hesap ile birden fazla sorumlu ilgilenebilir.
(
sgId int primary key identity(1,1),
SmId int foreign key references siteSosyalMedya(SmId) NOT NULL,
SSId int foreign key references sosyalSorumlular(SSId) NOT NULL
)


--

/*
aþaðýda siteAnket tablosu var, anket türleri ve anket bilgileri tutuluyor, ayrýca açýlan anketi üyelerin görüp görememesini belirleyebiliyoruz.. yanlarýnda da açýkladým. oluþturma sýralarýnýn farklý olmasý iliþkilendirmede sorun olmamasý için.
*/

create table anketTur --anket türleri bu tabloda tutulacak.
(
TurId int primary key identity(1,1),
TurAdi varchar(20) NOT NULL
)

create table siteAnket --anket ile ilgili bilgiler burada olacak.
(
AnktNo int primary key identity(1,1),
AnktAdi varchar(20) NOT NULL,
AnktAciklama varchar(200) NOT NULL,
TurId int foreign key references anketTur(TurId) NOT NULL
)

create table anketDuzey -- oluþturulan anketi sadece yöneticiler mi görsün yoksa üyeler de görebilsin mi?
(
DzNo int primary key identity(1,1),
DzDeger bit NOT NULL, -- 0 sadece yöneticiler, 1 üyeler
AnktNo int foreign key references siteAnket(AnktNo) NOT NULL
)

--

/*
aþaðýda mobilKategori tablosu var sitenin mobil uygulamasýn takibi içindir, mobil uygulama kategorisi ve bununla iliþkili 2 tablo bulunuyor, mobilVersiyon tablosunda uygulamalarýn versiyon bilgileri, mobilKullaniciSay tablosunda hangi iþletim sistemini kaç kullanýcý kullandýðý ve hangi versiyonu kullandýðý.. yanlarýnda da açýkladým. oluþturma sýralarýnýn farklý olmasý iliþkilendirmede sorun olmamasý için.
*/

create table mobilKategori --ana tablo bu, iþletim sistemi kullandýðý girilecek.
(
mkNo int primary key identity(1,1),
mkAdi varchar(20) NOT NULL,  --android, ios vb.
)

create table mobilVersiyon --iþletim sistemlerinin versiyonlarý girilece
(
mvNo int primary key identity(1,1),
mvVers float NOT NULL,
mkNo int foreign key references mobilKategori(mkNo) NOT NULL
)

create table mobilKullaniciSay
(
mkulId int primary key identity(1,1),
mkulSay int NOT NULL,
mkNo int foreign key references mobilKategori(mkNo) NOT NULL, --hangi iþletim sisteminden kullandýðý
mvNo int foreign key references mobilVersiyon(mvNo) NOT NULL --hangi versiyonu kullandýðý
)

-- 4. Her bir kategoriden en fazla yarýþan üyelerden hangilerinin en yüksek puaný aldýðýný, hangi kategoride yarýþtýðýný ve kaç soruyu doðru, kaç soruyu yanlýþ cevapladýðýný listeleyecek SQL sorgusunu yazýnýz.

SELECT sk.KtgAdi, MAX(COUNT(u.Uno)) as MaksYaris FROM uyelik u, uyeYaris uyrs, soruKategori sk
where u.Uno=uyrs.Uno and uyrs.KtgId=sk.KtgId
group by sk.KtgAdi

SELECT kt.KtgAdi, uy.Uno, uy.Uadi, MAX(uyrss.TplmPuan) as maksPuan FROM uyeYaris uyrss, uyelik uy, soruKategori kt, (SELECT sk.KtgId, MAX(COUNT(u.Uno)) as MaksYaris FROM uyelik u, uyeYaris uyrs, soruKategori sk
where u.Uno=uyrs.Uno and uyrs.KtgId=sk.KtgId
group by sk.KtgId) KtgYrs
where uyrss.KtgId=KtgYrs.KtgId and kt.KtgId=KtgYrs.KtgId

-- son hali, hata var.

SELECT KtgPuan.Uadi as 'Uye Adi', KtgPuan.KtgAdi as 'Kategori Adi', uyeyrs.dogruSay as 'Dogru Sayisi', uyeyrs.yanlisSay as 'Yanlis Sayisi' FROM uyeYaris uyeyrs, (SELECT kt.KtgAdi, uy.Uno, uy.Uadi, MAX(uyrss.TplmPuan) as maksPuan FROM uyeYaris uyrss, uyelik uy, soruKategori kt, (SELECT sk.KtgId, MAX(COUNT(u.Uno)) as MaksYaris FROM uyelik u, uyeYaris uyrs, soruKategori sk
where u.Uno=uyrs.Uno and uyrs.KtgId=sk.KtgId
group by sk.KtgId) KtgYrs
where uyrss.KtgId=KtgYrs.KtgId and kt.KtgId=KtgYrs.KtgId) KtgPuan
where uyeyrs.Uno=KtgPuan.Uno




-- 5. Bugüne kadar hiç soru göndermeyen ancak yarýþmaya katýlan üyelerin en yüksek puan aldýðý yarýþmada kaç soruyu doðru cevapladýðýný, kaç yanlýþý olduðunu listeleyecek SQL sorgusunu yazýnýz.


SELECT u.Uno, u.Uadi, MAX(uyrs.TplmPuan) as MaksPuan FROM uyeYaris uyrs, uyelik u
where u.Uno=uyrs.Uno and uyrs.Uno NOT IN (SELECT sg.Uno FROM soruGonder sg)
group by u.Uno, u.Uadi

-- son hali:

SELECT yaris.Uno as 'Uye No', yaris.Uadi as 'Uye Adi', yaris.MaksPuan 'En Yuksek Puani', uyrs.dogruSay 'Dogru Sayisi', uyrs.yanlisSay as 'Yanlis Sayisi' 
FROM uyeYaris uyrs, (SELECT u.Uno, u.Uadi, MAX(uyrs.TplmPuan) as MaksPuan FROM uyeYaris uyrs, uyelik u
where u.Uno=uyrs.Uno and uyrs.Uno NOT IN (SELECT sg.Uno FROM soruGonder sg) group by u.Uno, u.Uadi) yaris
where uyrs.Uno=yaris.Uno




-- 6. Bugüne kadar 20’den fazla soru gönderen ve hediye alan her bir üyenin her bir kategoriden, her bir zorluk düzeyinde kaç soru gönderdiðini listeleyecek bir SQL sorgusu yazýnýz ve kullanýnýz.

SELECT u.Uadi, COUNT(sg.Uno) FROM soruGonder sg, uyelik u
where u.Uno=sg.Uno and u.Uno in (SELECT Uno FROM istatistik i, hediye h where i.istNo=h.istNo)
group by u.Uadi having COUNT(sg.Uno)>20

SELECT sk.KtgAdi, sz.SzAdi, COUNT(sg.Sno) as 'Soru Sayisi' FROM soruGonder sg, soruKategori sk, soruZorluk sz
where sk.KtgId=sg.KtgId and sz.SzId=sg.SzId
group by sk.KtgAdi, sz.SzAdi

-- son hali:

SELECT u.Uno, u.Uadi as 'Uye Adi', sk.KtgAdi as 'Kategori Adi', sz.SzAdi as 'Zorluk Tur', COUNT(sg.Sno) as 'Soru Sayisi'
FROM uyelik u, soruGonder sg, soruKategori sk, soruZorluk sz
where u.Uno=sg.Uno and sk.KtgId=sg.KtgId and sz.SzId=sg.SzId and u.Uno in
(SELECT i.Uno FROM istatistik i, hediye h where i.istNo=h.istNo)
group by u.Uno, u.Uadi, sk.KtgAdi, sz.SzAdi having COUNT(sg.Sno)>20

--

select u.Uno, u.Uadi, Count(sg.Uno) from uyelik u, soruGonder sg
where u.Uno=sg.Uno
group by u.Uno, u.Uadi having Count(sg.Uno)>20

--

select sk.KtgAdi, sz.SzAdi ,u.Uno, u.Uadi, Count(sg.Uno) from uyelik u, soruGonder sg, soruKategori sk, soruZorluk sz
where u.Uno=sg.Uno and sg.KtgId=sk.KtgId and sg.SzId=sz.SzId
group by sk.KtgAdi, sz.SzAdi, u.Uno, u.Uadi having Count(sg.Uno)>20

--
select * from soruKategori sk, soruZorluk sz, (select u.Uno, u.Uadi, Count(sg.Uno) from uyelik u, soruGonder sg
where u.Uno=sg.Uno
group by u.Uno, u.Uadi having Count(sg.Uno)>20) uyegndSoru
where sk.