USE QUANLYBANHANG
GO
   
--BAITAP3:
   
-- 2.	Tạo quan hệ SANPHAM1 chứa toàn bộ dữ liệu của quan hệ SANPHAM. Tạo quan hệ KHACHHANG1 chứa toàn bộ dữ liệu của quan hệ KHACHHANG.
SELECT * INTO SANPHAM1 FROM SANPHAM
SELECT * INTO KHACHHANG1 FROM KHACHHANG
GO

-- 3.	Cập nhật giá tăng 5% đối với những sản phẩm do “Thai Lan” sản xuất (cho quan hệ SANPHAM1)
UPDATE SANPHAM1 SET GIA += GIA * 0.05 
WHERE NUOCSX = 'Thai Lan' 
GO

-- 4.	Cập nhật giá giảm 5% đối với những sản phẩm do “Trung Quoc” sản xuất có giá từ 10.000 trở xuống (cho quan hệ SANPHAM1).
UPDATE SANPHAM1 SET GIA -= GIA * 0.05 
WHERE NUOCSX = 'Trung Quoc' AND GIA <= 10000
GO

-- 5.	Cập nhật giá trị LOAIKH là “Vip” đối với những khách hàng đăng ký thành viên trước ngày 1/1/2007 có doanh số từ 
-- 10.000.000 trở lên hoặc khách hàng đăng ký thành viên từ 1/1/2007 trở về sau có doanh số từ 2.000.000 trở lên (cho quan hệ KHACHHANG1)
UPDATE KHACHHANG1 SET LOAIKH = 'VIP' 
WHERE (NGDK < '1/1/2007' AND DOANHSO >= 10000000) OR (NGDK > '1/1/2007' AND DOANHSO >= 2000000)
GO
