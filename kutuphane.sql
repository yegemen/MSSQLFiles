create database kutuphane

use kutuphane

create table adresler
(
adres_no int primary key identity(1,1),
cadde varchar(20),
mahalle varchar(20),
binano varchar(20),
sehir varchar(20),
posta_kodu int,
ulke varchar(20)
)

create table uyeler
(
uye_no int primary key identity(1,1),
uye_adi varchar(20),
uye_soyadi varchar(20),
cinsiyet varchar(5),
e_posta varchar(40),
adres_no int foreign key references adresler(adres_no)
)

create table kutuphane
(
kutuphane_no int primary key identity(1,1),
kutuhane_ismi varchar(20),
aciklama varchar(20),
adres_no int foreign key references adresler(adres_no)
)

create table kitaplar
(
isbn varchar(20) primary key,
kitap_adi varchar(20),
yayin_tarihi varchar(20),
s_sayisi int,
)

create table emanet
(
emanet_no int primary key identity(1,1),
isbn varchar(20) foreign key references kitaplar(isbn) not null,
uye_no int foreign key references uyeler(uye_no) not null,
kutuphane_no int foreign key references kutuphane(kutuphane_no) not null,
emanet_tarihi datetime,
teslim_tarihi datetime
)

create table yazarlar
(
yazar_no int primary key identity(1,1),
yazar_adı varchar(20),
yazar_soyadı varchar(20),
)

create table kategoriler
(
kategori_no int primary key identity(1,1),
kategori_adi varchar(20)
)

create table kitap_kutuphane
(
kutuphane_no int foreign key references kutuphane(kutuphane_no) not null,
isbn varchar(20) foreign key references kitaplar(isbn) not null,
miktar int,
constraint "kitap_kutuphane_pk" primary key ("kutuphane_no","isbn")
)

create table kitap_kategori
(
isbn varchar(20) foreign key references kitaplar(isbn) not null,
kategori_no int foreign key references kategoriler(kategori_no) not null
constraint "KTP_KTG_PK" primary key ("isbn", "kategori_no")
)

create table kitap_yazar
(
isbn varchar(20) foreign key references kitaplar(isbn) not null,
yazar_no int foreign key references yazarlar(yazar_no) not null,
constraint "kitap_yazar_pk" primary key ("isbn","yazar_no")
)