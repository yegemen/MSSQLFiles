create database obs

use obs

create table fakulte
(
id smallint primary key identity(1,1) not null,
ad nchar(30) not null
)

create table bolum
(
id smallint primary key identity(1,1) not null,
ad nchar(30) not null,
fakulte_id smallint foreign key references fakulte(id) null
)

create table ogrenci
(
numara bigint primary key identity(1,1) not null,
ad nchar(50) not null,
soyad nchar(50) not null,
e_posta nchar(50) null,
sifre binary(16) not null,
bolum_id smallint foreign key references bolum(id) null
)

create table akademisyen
(
id smallint primary key identity(1,1) not null,
tc_no bigint null,
ad nchar(50) not null,
soyad nchar(50) not null,
unvan nchar(25) null,
bolum_id smallint foreign key references bolum(id) null

-- bolum_d smallint,
-- constraint fk_akademisyen_bolum foreign key (bolum__id) references bolum(id) // constraint kullanarak yapmak daha avantajlý
)

create table ders
(
kod char(5) primary key not null,
ad nchar(25) not null,
kredi tinyint not null,
akts tinyint not null,
saat_teorik tinyint not null,
saat_uygulama tinyint not null,
yuzde_arasinav tinyint not null,
yuzde_final tinyint not null,
yuzde_odev tinyint not null,
yuzde_uygulama tinyint not null,
akademisyen_id smallint foreign key references akademisyen(id) null
)

