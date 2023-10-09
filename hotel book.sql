
SELECT
    rh.arrival_date_year AS tahun,
    rh.arrival_date_month AS bulan,
    COUNT(CASE WHEN EXTRACT(MONTH FROM rh.arrival_date_month) BETWEEN 1 AND 8 THEN 1 ELSE 0 END) AS jumlah_pengunjung,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS jumlah_pembatalan,
    SUM(CASE WHEN is_canceled = 0 THEN 1 ELSE 0 END) AS jumlah_tidak_dibatalkan
FROM resort_hotel rh 
GROUP BY tahun, bulan
ORDER BY tahun, jumlah_pembatalan desc;

SELECT adults, babies, children,
    CASE
        WHEN adults >0 AND (babies  <> 0 OR children <> 0) THEN 'family'
        ELSE 'not family' -- Atau nilai default lainnya jika diperlukan
    END AS cust_category
FROM hotel_book hb ;

   
SELECT
    STR_TO_DATE(CONCAT(arrival_date_year, '-', arrival_date_month, '-', arrival_date_day_of_month), '%Y-%M-%d') AS arrived_date
FROM
    hotel_book;
   
SELECT
    hb.arrival_date_year AS tahun,
    hb.arrival_date_month AS bulan,
    COUNT(CASE WHEN EXTRACT(MONTH FROM hb.arrival_date_month) BETWEEN 1 AND 8 THEN 1 ELSE 0 END) AS jumlah_pengunjung,
    SUM(CASE WHEN is_repeated_guest = 1 THEN 1 ELSE 0 END) AS jumlah_repeat,
    SUM(CASE WHEN is_repeated_guest = 0 THEN 1 ELSE 0 END) AS jumlah_tidak_repeat
FROM hotel_book hb  
where hotel = "Resort Hotel"
GROUP BY tahun, bulan
ORDER BY tahun, jumlah_repeat desc;
   
   
   -- TRANFORM DATA KOLOM BABIES, ADULT, CHILDERN JADI CUST CATEGORY

   -- creat new table dan mengambil data yg dibutuhkan dari tabel lama

CREATE TABLE resort_hotel (
    hotel varchar(50),
    is_canceled int(11),
    lead_time int(11),
    arrival_date_year INT(11),
    arrival_date_month varchar(50),
    arrival_date_day_of_month INT(11),
    adults int(11),
    children int(11),
    babies int(11),
    country varchar(50),
    market_segment varchar(50),
    is_repeated int(11),
    deposit_type varchar(50),
    reserved_room_type varchar(50),
    assigned_room_type varchar(50),
    reservation_status varchar(50),
    reservation_status_date varchar(50)
     
);

-- memasukkan data dari table lama

insert into resort_hotel (hotel, is_canceled,  lead_time, arrival_date_year, arrival_date_month, arrival_date_day_of_month, 
adults, children, babies, country, market_segment, is_repeated, deposit_type, reserved_room_type, assigned_room_type, 
reservation_status, reservation_status_date)
select hotel, is_canceled,  lead_time, arrival_date_year, arrival_date_month, arrival_date_day_of_month, 
adults, children, babies, country, market_segment, is_repeated_guest, deposit_type, reserved_room_type, assigned_room_type, 
reservation_status, reservation_status_date
from hotel_book 
where hotel = "Resort Hotel" ;

-- update table

alter table resort_hotel 
add cust_category varchar(50);

update resort_hotel 
set cust_category =
CASE
        WHEN adults >0 AND (babies  <> 0 OR children <> 0) THEN 'family'
        ELSE 'not family' 
    end;
   
  commit;
 
 select * from resort_hotel rh 
 where arrival_date_year = '2016'
 
 -- menampilkan data jumlah booking
SELECT
    rh.arrival_date_year AS tahun,
    rh.arrival_date_month AS bulan,
    COUNT(hotel) AS jumlah_booking
FROM resort_hotel rh 
where rh.arrival_date_year = '2017'
GROUP BY tahun, bulan
ORDER BY tahun, jumlah_booking desc;

-- menampilkan data rekomendasi kamar buat cust category 'family' 3 tshun
SELECT  rh.arrival_date_year AS tahun,
    	rh.arrival_date_month AS bulan,
		assigned_room_type, COUNT(*) AS jumlah_pemesan
FROM resort_hotel rh 
WHERE cust_category = 'family'
GROUP BY tahun, bulan
ORDER BY tahun, jumlah_pemesan DESC;


select  rh.arrival_date_year AS tahun,
    	rh.arrival_date_month AS bulan,
		assigned_room_type, COUNT(*) AS jumlah_pemesan
FROM resort_hotel rh 
GROUP BY tahun, bulan
ORDER BY tahun, jumlah_pemesan DESC;


SELECT
    rh.arrival_date_year AS tahun,
    rh.arrival_date_month AS bulan,
    COUNT(hotel) AS jumlah_pengunjung,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS jumlah_pembatalan,
    SUM(CASE WHEN is_canceled = 0 THEN 1 ELSE 0 END) AS jumlah_tidak_dibatalkan
FROM resort_hotel rh 
GROUP BY tahun, bulan
ORDER BY tahun, jumlah_pembatalan desc;


SELECT market_segment, COUNT(*) AS jumlah_pembatalan
FROM resort_hotel rh 
WHERE is_canceled = 1 and arrival_date_year = '2017' and arrival_date_month = '2015','2016', '2017'
GROUP BY market_segment
ORDER BY jumlah_pembatalan DESC;


SELECT arrival_date_month ,
		market_segment, COUNT(*) AS jumlah_pembatalan
FROM resort_hotel
WHERE is_canceled = 1
    AND arrival_date_year = 2017
    AND arrival_date_month IN ('June', 'July', 'August')
GROUP BY arrival_date_month , market_segment
ORDER BY  jumlah_pembatalan DESC;

SELECT
SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS jumlah_pembatalan	
FROM resort_hotel rh
WHERE reserved_room_type <> assigned_room_type
and is_canceled = 1;

select reserved_room_type, assigned_room_type
FROM resort_hotel rh 
WHERE reserved_room_type <> assigned_room_type;




