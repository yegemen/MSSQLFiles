--Veritabaný oluþturma

create database OtoGaleri

use OtoGaleri

create table musteri(
MNo int primary key identity(1,1) NOT NULL,
MAdi varchar(50) NOT NULL,
MSoyadi varchar(100) NOT NULL,
MAdres text NULL DEFAULT('Bilecik'),
MTel varchar(15) NULL

)

create table arac
(
ANo int Primary key identity(1,1) NOT NULL,
Plaka varchar(15) NOT NULL,
Marka varchar(15) NOT NULL,
Model varchar(15) NOT NULL,
AFiyat money NOT NULL
)

create table alim
(
AlNo int primary key identity(1,1) NOT NULL,
MNo int foreign key references Musteri(MNo),
ANo int foreign key references Arac(ANo),
AlTrh datetime,
Alfiyat money
)

create table satis
(
StNo int primary key identity(1,1) NOT NULL,
MNo int foreign key references Musteri(MNo),
ANo int foreign key references Arac(ANo),
StTrh datetime,
Stfiyat money
)