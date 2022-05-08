CREATE DATABASE obs2;

USE obs2;

CREATE TABLE fakulte
(
id smallint NOT NULL IDENTITY(1,1),
ad nchar(50) NOT NULL,
CONSTRAINT fakulte_pk PRIMARY KEY (id)
)

CREATE TABLE bolum
(
id smallint NOT NULL IDENTITY(1,1),
ad nchar(50) NOT NULL,
fakulte_id smallint,
CONSTRAINT PK PRIMARY KEY (id),
CONSTRAINT fk_bolum_fakulte FOREIGN KEY (fakulte_id)
REFERENCES fakulte (id)
)

CREATE TABLE ogrenci
(
numara bigint NOT NULL,
ad nchar(50) NOT NULL,
soyad nchar(50) NOT NULL,
e_posta char(50),
sifre binary(16) NOT NULL,
kayit_tarihi date,
bolum_id smallint,
CONSTRAINT pk_ogrenci PRIMARY KEY (numara),
CONSTRAINT fk_ogrenci_bolum FOREIGN KEY (bolum_id)
REFERENCES bolum (id)
)

CREATE TABLE akademisyen
(
id smallint NOT NULL IDENTITY(1,1),
CONSTRAINT pk_akademisyen PRIMARY KEY (id),
tc_no bigint,
ad nchar(50) NOT NULL,
soyad nchar(50) NOT NULL,
unvan nchar(25),
bolum_id smallint,
CONSTRAINT fk_akademisyen_bolum FOREIGN KEY (bolum_id) REFERENCES bolum (id)
)

CREATE TABLE ders
(
kod char(5) NOT NULL,
CONSTRAINT pk_ders PRIMARY KEY (kod),
ad nchar(25) NOT NULL,
kredi tinyint NOT NULL,
akts tinyint NOT NULL,
saat_teorik tinyint NOT NULL,
saat_uygulama tinyint NOT NULL,
yuzde_arasinav tinyint NOT NULL,
yuzde_final tinyint NOT NULL,
yuzde_odev tinyint NOT NULL,
yuzde_uygulama tinyint NOT NULL,
akademisyen_id smallint,
CONSTRAINT fk_ders_akademisyen FOREIGN KEY (akademisyen_id)
REFERENCES akademisyen (id)
)

insert into fakulte (ad) values ('muhendislik')
insert into fakulte (ad) values ('iibf')
insert into fakulte (ad) values ('saglik')

insert into bolum (ad,fakulte_id) 
values 
('bilgisayar',(select id from fakulte where ad = 'muhendislik')),
('isletme',2),
('hemsirelik',3)

insert into ogrenci (numara,ad,soyad,e_posta,sifre,kayit_tarihi,bolum_id)
values
(123,'yusuf','cicek','yegemen1616@gmail.com',hashbytes ('MD5','12345'),'2018-09-20',1),
(456,'ali','eee','ahmet@gmail.com',hashbytes ('MD5','12345'),'2018-09-20',2),
(789,'ahmet','ccc','ahmet@gmail.com',hashbytes ('MD5','12345'),'2018-09-20',3)

insert into akademisyen (tc_no,ad,soyad,unvan,bolum_id)
values
(111,'veli','asd','doç',1),
(222,'mehmet','dsa','doç',2),
(333,'halil','sss','doç',3)

insert into ders (kod,ad,kredi,akts,saat_teorik,saat_uygulama,yuzde_arasinav,yuzde_final,yuzde_odev,yuzde_uygulama,akademisyen_id)
values
(534,'elektronik_devreler',5,5,3,0,40,60,0,0,1),
(454,'veri_yapilari',6,6,4,2,40,60,0,0,1),
(231,'veri_tabani',5,5,4,2,40,60,0,0,1)

update ders set kod=235, akademisyen_id=2 where ad='elektronik_devreler'

update ogrenci set e_posta='ahmet123@gmail.com' where ad='ahmet' and soyad='ccc'

delete from ders where yuzde_final<40

delete from ders where kod<>'BM' and yuzde_final>60

select yuzde_final, yuzde_uygulama, akademisyen_id from ders where ad like '%A%'

select ad,soyad,e_posta from ogrenci where kayit_tarihi between '2018-09-20' and '2018-09-25'

select ad from ders where yuzde_uygulama<15 