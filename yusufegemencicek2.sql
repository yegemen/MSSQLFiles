select avg(not_arasinav) as 'Ara sinav ortalama' from ogrenci_ders where ders_kod='BM210'

select count(*) as 'ogrenci sayisi' from ogrenci_ders where ders_kod='BM210'

select max(not_final) as 'en yuksek final notu' from ogrenci_ders where ders_kod='BM210'

select min(not_uygulama) as 'en dusuk uygulama' from ogrenci_ders where ders_kod='BM210'

select sum(not_odev)/count(*) as 'ortalama odev not' from ogrenci_ders where ders_kod='BM210'