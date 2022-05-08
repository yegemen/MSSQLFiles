create table egitim_duzey
(
egId int primary key identity(1,1),
duzey varchar(20)
)

create table film_tur
(
turId int primary key identity(1,1),
turAdi varchar(20)
)

create table musteri
(
mus_no int primary key identity(1,1),
adi varchar(20),
soyadi varchar(20),
cinsiyeti bit,
cocuk int,
egId int foreign key references egitim_duzey(egId)
)

create table film
(
film_no int primary key identity(1,1),
adi varchar(20),
odunc bit,
turId int foreign key references film_tur(turID)
)

create table oyuncu_film
(
oyyonId int primary key identity(1,1),
adi varchar(20),
soyadi varchar(20),
oyyon bit
)

create table oy_yon_film
(
film_no int foreign key references film(film_no),
oyyonId int foreign key references oyuncu_film(oyyonId)
)

create table musteri_oyuncu
(
moId int primary key identity(1,1),
film_no int foreign key references film(film_no),
oyyonId int foreign key references oyuncu_film(oyyonId),
mus_no int foreign key references musteri(mus_no)
)

create table musteri_film
(
odunc_Id int primary key identity(1,1),
alim_tarih date,
getir_tarih date,
mus_no int foreign key references musteri(mus_no),
film_no int foreign key references film(film_no)
)