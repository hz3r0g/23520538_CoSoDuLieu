USE QUANLYBANHANG
GO

-- 1.	In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất.
SELECT MASP, TENSP FROM SANPHAM 
WHERE NUOCSX = 'Trung Quoc'
GO

-- 2.	In ra danh sách các sản phẩm (MASP,TENSP) có đơn vị tính là “cay”, ”quyen”.
SELECT MASP, TENSP FROM SANPHAM 
WHERE DVT IN ('cay', 'quyen')
GO

-- 3.	In ra danh sách các sản phẩm (MASP,TENSP) có mã sản phẩm bắt đầu là “B” và kết thúc là “01”.
SELECT MASP, TENSP FROM SANPHAM 
WHERE LEFT(MASP, 1) = 'B' AND RIGHT(MASP, 2) = '01'
GO

-- 4.	In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quốc” sản xuất có giá từ 30.000 đến 40.000.
SELECT MASP, TENSP FROM SANPHAM 
WHERE NUOCSX = 'Trung Quoc' AND GIA BETWEEN 30000 AND 40000
GO

-- 5.	In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” hoặc “Thai Lan” sản xuất có giá từ 30.000 đến 40.000.
SELECT MASP,TENSP FROM SANPHAM 
WHERE (NUOCSX IN ('Trung Quoc', ' Thai Lan')) AND (GIA BETWEEN 30000 AND 40000)
GO

-- 6.	In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 1/1/2007 và ngày 2/1/2007.
SELECT SOHD, TRIGIA FROM HOADON 
WHERE NGHD IN ('1/1/2007', '2/1/2007')
GO

-- 7.	In ra các số hóa đơn, trị giá hóa đơn trong tháng 1/2007, sắp xếp theo ngày (tăng dần) và trị giá của hóa đơn (giảm dần).
SELECT SOHD, TRIGIA FROM HOADON 
WHERE YEAR(NGHD) = 2007 AND MONTH(NGHD) = 1 
ORDER BY NGHD ASC, TRIGIA DESC
GO

-- 8.	In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 1/1/2007.
SELECT HD.MAKH, HOTEN 
FROM HOADON HD INNER JOIN KHACHHANG KH 
ON HD.MAKH = KH.MAKH 
WHERE NGHD = '1/1/2007'
GO

-- 9.	In ra số hóa đơn, trị giá các hóa đơn do nhân viên có tên “Nguyen Van B” lập trong ngày 28/10/2006.
SELECT HD.SOHD, HD.TRIGIA 
FROM HOADON HD INNER JOIN NHANVIEN NV 
ON HD.MANV = NV.MANV 
WHERE HOTEN = 'Nguyen Van B' AND NGHD = '2006/10/28'
GO

-- 10.	In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” mua trong tháng 10/2006.
SELECT CT.MASP, TENSP 
FROM CTHD CT INNER JOIN SANPHAM SP 
ON CT.MASP = SP.MASP
WHERE SOHD IN (
	SELECT SOHD 
	FROM HOADON HD INNER JOIN KHACHHANG KH 
	ON HD.MAKH = KH.MAKH
	WHERE HOTEN = 'Nguyen Van A' AND YEAR(NGHD) = 2006 AND MONTH(NGHD) = 10 
)
GO

-- 11.	Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”.
SELECT SOHD FROM CTHD WHERE MASP = 'BB01' 
UNION
SELECT SOHD FROM CTHD WHERE MASP = 'BB02' 
GO