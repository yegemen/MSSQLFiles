create database ornek

use ornek

create table mekanlar
(
	MekanId int primary key identity(1,1),
	MakanAdi varchar(50)
)

create table rezervasyon
(
	RezervasyonId int primary key identity(1,1),
	RezervasyonTarihi Date,
	RezervasyonSaati time,
	KisiSayisi int,
	MekanId int foreign key references mekanlar(MekanId)
)

create table musteriler
(
	MusteriId int primary key identity(1,1),
	MusteriAd varchar(20),
	MusteriSoyad varchar(20),
	MusteriTel varchar(12),
	RezervasyonId int foreign key references rezervasyon(RezervasyonId),
	MusteriEmail varchar(50),
	Aciklama Varchar(150)
)

create table il
(
	ilId int primary key identity(1,1),
	Tanim varchar(100)
)

create table ilce
(
	ilceId int primary key identity(1,1),
	Tanim varchar(100)
)

create table mutfaklar
(
	MutfakId int primary key identity(1,1),
	Tanim varchar(50)
)

create table yersecimi
(
	YerSecimId int primary key identity(1,1),
	ilId int foreign key references il(ilId),
	ilceId int foreign key references ilce(ilceId),
	MutfakId int foreign key references mutfaklar(MutfakId),
	MekanId int foreign key references mekanlar(MekanId)
)
