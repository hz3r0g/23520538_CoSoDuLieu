﻿CREATE DATABASE QUANLYBANHANG

USE QUANLYBANHANG

--Bang KHACHHANG--
CREATE TABLE KHACHHANG
(
	MAKH CHAR(4) PRIMARY KEY, 
	HOTEN VARCHAR(40) NOT NULL,
	DCHI VARCHAR(50) NOT NULL,
	SODT VARCHAR(20) NOT NULL,
	NGSINH SMALLDATETIME,
	NGDK SMALLDATETIME,
	DOANHSO MONEY NOT NULL
)

--Bang NHANVIEN--
CREATE TABLE NHANVIEN
(
	MANV CHAR(4) PRIMARY KEY,
	HOTEN VARCHAR(40) NOT NULL,
	SODT VARCHAR(20) NOT NULL,
	NGVL SMALLDATETIME
)
--Bang SANPHAM--
CREATE TABLE SANPHAM
(
	MASP CHAR(4) PRIMARY KEY,
	TENSP VARCHAR(40) NOT NULL,
	DVT VARCHAR(20),
	NUOCSX VARCHAR(40),
	GIA MONEY NOT NULL
)

--Bang HOADON--
CREATE TABLE HOADON
(
	SOHD INT PRIMARY KEY,
	NGHD SMALLDATETIME,
	MAKH CHAR(4) FOREIGN KEY REFERENCES KHACHHANG(MAKH),
	MANV CHAR(4) FOREIGN KEY REFERENCES NHANVIEN(MANV),
	TRIGIA MONEY
)

--Bang CTHD--
CREATE TABLE CTHD
(
	SOHD INT FOREIGN KEY REFERENCES HOADON(SOHD),
	MASP CHAR(4) FOREIGN KEY REFERENCES SANPHAM(MASP),
	SL INT,
	PRIMARY KEY (SOHD, MASP)
)

-- 2.Them thuoc tinh GHICHU co kieu du lieu varchar(20) cho quan he SANPHAM
ALTER TABLE SANPHAM ADD GHICHU VARCHAR(20)

-- 3.Them thuoc tinh LOAIKH co kieu du lieu tinyint cho quan he KHACHHANG
ALTER TABLE KHACHHANG ADD LOAIKH TINYINT

-- 4.Sua kieu du lieu của thuoc tinh GHICHU trong quan he SANPHAM thanh varchar(100)
ALTER TABLE SANPHAM ALTER COLUMN GHICHU VARCHAR(100)

-- 5.Xoa thuộc tính GHICHU trong quan he SANPHAM.
ALTER TABLE SANPHAM DROP COLUMN GHICHU

-- 6.Lam the nao de thuoc tinh LOAIKH trong quan he KHACHHANG co the luu cac gia tri la: “Vang lai”, “Thuong xuyen”, “Vip”, …
ALTER TABLE KHACHHANG ALTER COLUMN LOAIKH VARCHAR(20)

-- 7.Don vi tinh cua san pham chi co the la (“cay”,”hop”,”cai”,”quyen”,”chuc”)
ALTER TABLE SANPHAM ADD CONSTRAINT CK_DVT CHECK(DVT in ('cay', 'hop', 'cai', 'quyen', 'chuc'))

-- 8.Gia ban cua san pham tu 500 đong tro len
ALTER TABLE SANPHAM ADD CONSTRAINT CK_GIA CHECK(GIA >= 500)

-- 9.Moi lan mua hang, khach hang phai mua it nhat 1 san pham
ALTER TABLE CTHD ADD CONSTRAINT CK_SL CHECK(SL >= 1)

-- 10.Ngay khach hang dang ky la khach hang thanh vien phai lon hon ngay sinh cua nguoi đo
ALTER TABLE KHACHHANG ADD CONSTRAINT CK_NGDK CHECK(NGDK > NGSINH)