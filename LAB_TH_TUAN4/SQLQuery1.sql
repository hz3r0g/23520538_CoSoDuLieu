﻿-- QUANLYBANHANG --
SET DATEFORMAT DMY;
USE QUANLYBANHANG
GO

-- III. Ngôn ngữ truy vấn dữ liệu có cấu trúc:
-- 20.	Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua?
SELECT COUNT(*) FROM HOADON
WHERE MAKH NOT IN(
	SELECT MAKH FROM KHACHHANG 
	WHERE KHACHHANG.MAKH = HOADON.MAKH
)
GO

-- 21.	Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.
SELECT COUNT(DISTINCT MASP) 
FROM CTHD CT INNER JOIN HOADON HD
ON CT.SOHD = HD.SOHD
WHERE YEAR(NGHD) = '2006'
GO

-- 22.	Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu ?
SELECT MIN(TRIGIA) GIAMIN, MAX(TRIGIA) GIAMAX FROM HOADON
GO

-- 23.	Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
SELECT AVG(TRIGIA) FROM HOADON WHERE YEAR(NGHD) = '2006'
GO

-- 24.	Tính doanh thu bán hàng trong năm 2006.
SELECT SUM(TRIGIA) FROM HOADON WHERE YEAR(NGHD) = '2006'
GO

-- 25.	Tìm số hóa đơn có trị giá cao nhất trong năm 2006.
SELECT SOHD FROM HOADON
WHERE YEAR(NGHD) = '2006' AND TRIGIA = (
	SELECT MAX(TRIGIA) FROM HOADON
)
GO

-- 26.	Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
SELECT HOTEN FROM HOADON HD INNER JOIN KHACHHANG KH
ON HD.MAKH = KH.MAKH
WHERE YEAR(NGHD) = '2006' AND TRIGIA = (
	SELECT MAX(TRIGIA) FROM HOADON
)
GO

-- 27.	In ra danh sách 3 khách hàng (MAKH, HOTEN) có doanh số cao nhất.
SELECT TOP 3 MAKH, HOTEN FROM KHACHHANG ORDER BY DOANHSO DESC
GO

-- 28.	In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất.
SELECT MASP, TENSP FROM SANPHAM
WHERE GIA IN(
	SELECT DISTINCT TOP 3 GIA FROM SANPHAM
	ORDER BY GIA DESC
)
GO

-- 29.	In ra danh sách các sản phẩm (MASP, TENSP) do “Thai Lan” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của tất cả các sản phẩm).
SELECT MASP, TENSP FROM SANPHAM
WHERE NUOCSX = 'Thai Lan' AND GIA IN(
	SELECT DISTINCT TOP 3 GIA FROM SANPHAM
	ORDER BY GIA DESC
)
GO

-- 30.	In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất).
SELECT MASP, TENSP FROM SANPHAM
WHERE NUOCSX = 'Trung Quoc' AND GIA IN(
	SELECT DISTINCT TOP 3 GIA FROM SANPHAM
	WHERE NUOCSX = 'Trung Quoc'
	ORDER BY GIA DESC
)
GO

-- 31.	* In ra danh sách 3 khách hàng có doanh số cao nhất (sắp xếp theo kiểu xếp hạng).
SELECT TOP 3 MAKH, HOTEN, RANK() OVER (ORDER BY DOANHSO DESC) RANK_KH FROM KHACHHANG
GO

-- 32.	Tính tổng số sản phẩm do “Trung Quoc” sản xuất.
SELECT COUNT(MASP) FROM SANPHAM WHERE NUOCSX = 'Trung Quoc'
GO

-- 33.	Tính tổng số sản phẩm của từng nước sản xuất.?
SELECT NUOCSX, COUNT(MASP) SOSP FROM SANPHAM GROUP BY NUOCSX
GO

-- 34.	Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm.
SELECT NUOCSX, MAX(GIA) GIAMAX, MIN(GIA) GIAMIN, AVG(GIA) TRUNGBINH FROM SANPHAM GROUP BY NUOCSX
GO

-- 35.	Tính doanh thu bán hàng mỗi ngày.
SELECT NGHD, SUM(TRIGIA) DOANHTHU FROM HOADON GROUP BY NGHD
GO

-- 36.	Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.
SELECT  CT.MASP, SUM(SL) SL
FROM CTHD CT INNER JOIN HOADON HD 
ON CT.SOHD = HD.SOHD
WHERE YEAR(NGHD) = '2006' AND MONTH(NGHD) = '10'
GROUP BY CT.MASP
GO

-- 37.	Tính doanh thu bán hàng của từng tháng trong năm 2006.
SELECT MONTH(NGHD) THANG, SUM(TRIGIA) DOANHTHU
FROM HOADON 
WHERE YEAR(NGHD) = '2006'
GROUP BY MONTH(NGHD)
GO

-- 38.	Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.
SELECT SOHD FROM CTHD
GROUP BY SOHD 
HAVING COUNT(DISTINCT MASP) >= 4
GO

-- 39.	Tìm hóa đơn có mua 3 sản phẩm do “Viet Nam” sản xuất (3 sản phẩm khác nhau).
SELECT SOHD FROM CTHD CT INNER JOIN SANPHAM SP
ON CT.MASP = SP.MASP
WHERE NUOCSX = 'Viet Nam'
GROUP BY SOHD 
HAVING COUNT(DISTINCT CT.MASP) = 3
GO

-- 40.	Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất. 
SELECT MAKH, HOTEN FROM (
	SELECT HD.MAKH, HOTEN, RANK() OVER (ORDER BY COUNT(HD.MAKH) DESC) RANK_SOLAN 
	FROM HOADON HD INNER JOIN KHACHHANG KH 
	ON HD.MAKH = KH.MAKH
	GROUP BY HD.MAKH, HOTEN
) A
WHERE RANK_SOLAN = 1
GO

-- 41.	Tháng mấy trong năm 2006, doanh số bán hàng cao nhất ?
SELECT THANG FROM (
	SELECT MONTH(NGHD) THANG, RANK() OVER (ORDER BY SUM(TRIGIA) DESC) RANK_TRIGIA FROM HOADON
	WHERE YEAR(NGHD) = '2006' 
	GROUP BY MONTH(NGHD)
) A
WHERE RANK_TRIGIA = 1
GO

-- 42.	Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006.
SELECT A.MASP, TENSP FROM (
	SELECT MASP, RANK() OVER (ORDER BY SUM(SL)) RANK_SL
	FROM CTHD CT INNER JOIN HOADON HD
	ON CT.SOHD = HD.SOHD
	WHERE YEAR(NGHD) = '2006'
	GROUP BY MASP
) A INNER JOIN SANPHAM SP
ON A.MASP = SP.MASP
WHERE RANK_SL = 1
GO

-- 43.	*Mỗi nước sản xuất, tìm sản phẩm (MASP,TENSP) có giá bán cao nhất.
SELECT NUOCSX, MASP, TENSP FROM (
	SELECT NUOCSX, MASP, TENSP, GIA, RANK() OVER (PARTITION BY NUOCSX ORDER BY GIA DESC) RANK_GIA FROM SANPHAM
) A 
WHERE RANK_GIA = 1
GO

-- 44.	Tìm nước sản xuất sản xuất ít nhất 3 sản phẩm có giá bán khác nhau.
SELECT NUOCSX FROM SANPHAM 
GROUP BY NUOCSX
HAVING COUNT(DISTINCT GIA) >= 3
GO

-- 45.	*Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều nhất.
SELECT MAKH, HOTEN FROM (
	SELECT TOP 10 HD.MAKH, HOTEN, DOANHSO, RANK() OVER (ORDER BY COUNT(HD.MAKH) DESC) RANK_SOLAN 
	FROM HOADON HD INNER JOIN KHACHHANG KH 
	ON HD.MAKH = KH.MAKH
	GROUP BY HD.MAKH, HOTEN, DOANHSO
	ORDER BY DOANHSO DESC
) A
WHERE RANK_SOLAN = 1
GO

-- QUANLYHOCVU --
USE QUANLYGIAOVU
GO

-- III. Ngôn ngữ truy vấn dữ liệu:
-- 19.	Khoa nào (mã khoa, tên khoa) được thành lập sớm nhất.
SELECT MAKHOA, TENKHOA FROM (
	SELECT MAKHOA, TENKHOA, RANK() OVER (ORDER BY NGTLAP) RANK_NGTLAP FROM KHOA 
) A
WHERE RANK_NGTLAP = 1
GO

-- 20.	Có bao nhiêu giáo viên có học hàm là “GS” hoặc “PGS”.
SELECT HOCHAM, COUNT(HOCHAM) SL FROM GIAOVIEN 
WHERE HOCHAM IN ('GS', 'PGS') 
GROUP BY HOCHAM
GO

-- 21.	Thống kê có bao nhiêu giáo viên có học vị là “CN”, “KS”, “Ths”, “TS”, “PTS” trong mỗi khoa.
SELECT MAKHOA, HOCVI, COUNT(HOCVI) SL FROM GIAOVIEN 
GROUP BY MAKHOA, HOCVI
ORDER BY MAKHOA
GO

-- 22.	Mỗi môn học thống kê số lượng học viên theo kết quả (đạt và không đạt).
SELECT MAMH, KQUA, COUNT(MAHV) SL
FROM KETQUATHI A
WHERE NOT EXISTS (
	SELECT 1 
	FROM KETQUATHI B 
	WHERE A.MAHV = B.MAHV AND A.MAMH = B.MAMH AND A.LANTHI < B.LANTHI
)
GROUP BY MAMH, KQUA
GO

-- 23.	Tìm giáo viên (mã giáo viên, họ tên) là giáo viên chủ nhiệm của một lớp, đồng thời dạy cho lớp đó ít nhất một môn học.
SELECT MAGV, HOTEN 
FROM GIAOVIEN 
WHERE MAGV IN(
	SELECT DISTINCT MAGV
	FROM GIANGDAY GD INNER JOIN LOP
	ON GD.MALOP = LOP.MALOP
	WHERE MAGV = MAGVCN 
)
GO

-- 24.	Tìm họ tên lớp trưởng của lớp có sỉ số cao nhất.

SELECT HO + ' ' + TEN HOTEN FROM LOP INNER JOIN HOCVIEN HV
ON LOP.TRGLOP = HV.MAHV
WHERE SISO = (
	SELECT MAX(SISO) FROM LOP
)
GO

-- 25.	* Tìm họ tên những LOPTRG thi không đạt quá 3 môn (mỗi môn đều thi không đạt ở tất cả các lần thi).
SELECT HO + ' ' + TEN HOTEN FROM HOCVIEN
WHERE MAHV IN (
	SELECT MAHV FROM KETQUATHI A
	WHERE MAHV IN (
		SELECT TRGLOP FROM LOP
	) AND NOT EXISTS (
		SELECT 1 FROM KETQUATHI B 
		WHERE A.MAHV = B.MAHV AND A.MAMH = B.MAMH AND A.LANTHI < B.LANTHI
	) AND KQUA = 'Khong Dat'
	GROUP BY MAHV
	HAVING COUNT(MAMH) >= 3
)
GO

-- 26.	Tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9,10 nhiều nhất.
SELECT A.MAHV, HO + ' ' + TEN HOTEN FROM (
	SELECT MAHV, RANK () OVER (ORDER BY COUNT(MAMH) DESC) RANK_MH FROM KETQUATHI KQ 
	WHERE DIEM BETWEEN 9 AND 10
	GROUP BY KQ.MAHV
) A INNER JOIN HOCVIEN HV
ON A.MAHV = HV.MAHV
WHERE RANK_MH = 1

GO

-- 27.	Trong từng lớp, tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9,10 nhiều nhất.
SELECT LEFT(A.MAHV, 3) MALOP, A.MAHV, HO + ' ' + TEN HOTEN FROM (
	SELECT MAHV, RANK () OVER (ORDER BY COUNT(MAMH) DESC) RANK_MH FROM KETQUATHI KQ 
	WHERE DIEM BETWEEN 9 AND 10
	GROUP BY KQ.MAHV
) A INNER JOIN HOCVIEN HV
ON A.MAHV = HV.MAHV
WHERE RANK_MH = 1
GROUP BY LEFT(A.MAHV, 3), A.MAHV, HO, TEN
GO

-- 28.	Trong từng học kỳ của từng năm, mỗi giáo viên phân công dạy bao nhiêu môn học, bao nhiêu lớp.
SELECT HOCKY, NAM, MAGV, COUNT(MAMH) SOMH, COUNT(MALOP) SOLOP FROM GIANGDAY
GROUP BY HOCKY, NAM, MAGV
GO

-- 29.	Trong từng học kỳ của từng năm, tìm giáo viên (mã giáo viên, họ tên) giảng dạy nhiều nhất.
SELECT HOCKY, NAM, A.MAGV, HOTEN FROM (
	SELECT HOCKY, NAM, MAGV, RANK() OVER (PARTITION BY HOCKY, NAM ORDER BY COUNT(MAMH) DESC) RANK_SOMH FROM GIANGDAY
	GROUP BY HOCKY, NAM, MAGV
) A INNER JOIN GIAOVIEN GV 
ON A.MAGV = GV.MAGV
WHERE RANK_SOMH = 1
GO

-- 30.	Tìm môn học (mã môn học, tên môn học) có nhiều học viên thi không đạt (ở lần thi thứ 1) nhất.
SELECT A.MAMH, TENMH FROM (
	SELECT MAMH, RANK() OVER (ORDER BY COUNT(MAHV) DESC) RANK_SOHV FROM KETQUATHI
	WHERE LANTHI = 1 AND KQUA = 'Khong Dat'
	GROUP BY MAMH
) A INNER JOIN MONHOC MH
ON A.MAMH = MH.MAMH
WHERE RANK_SOHV = 1
GO

-- 31.	Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi thứ 1).
SELECT A.MAHV, HO + ' ' + TEN HOTEN FROM (
	SELECT MAHV, COUNT(KQUA) SODAT FROM KETQUATHI 
	WHERE LANTHI = 1 AND KQUA = 'Dat'
	GROUP BY MAHV
	INTERSECT
	SELECT MAHV, COUNT(MAMH) SOMH FROM KETQUATHI 
	WHERE LANTHI = 1
	GROUP BY MAHV
) A INNER JOIN HOCVIEN HV
ON A.MAHV = HV.MAHV

-- 32.	* Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi sau cùng).
SELECT C.MAHV, HO + ' ' + TEN HOTEN FROM (
	SELECT MAHV, COUNT(KQUA) SODAT FROM KETQUATHI A
	WHERE NOT EXISTS (
		SELECT 1 
		FROM KETQUATHI B 
		WHERE A.MAHV = B.MAHV AND A.MAMH = B.MAMH AND A.LANTHI < B.LANTHI
	) AND KQUA = 'Dat'
	GROUP BY MAHV
	INTERSECT
	SELECT MAHV, COUNT(MAMH) SOMH FROM KETQUATHI 
	WHERE LANTHI = 1
	GROUP BY MAHV
) C INNER JOIN HOCVIEN HV
ON C.MAHV = HV.MAHV
GO

-- 33.	* Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn đều đạt (chỉ xét lần thi thứ 1).
SELECT A.MAHV, HO + ' ' + TEN HOTEN FROM (
	SELECT MAHV, COUNT(KQUA) SODAT FROM KETQUATHI 
	WHERE LANTHI = 1 AND KQUA = 'Dat'
	GROUP BY MAHV
	INTERSECT
	SELECT MAHV, COUNT(MAMH) SOMH FROM KETQUATHI 
	WHERE LANTHI = 1
	GROUP BY MAHV
) A INNER JOIN HOCVIEN HV
ON A.MAHV = HV.MAHV
GO

-- 34.	* Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn đều đạt  (chỉ xét lần thi sau cùng).
SELECT C.MAHV, HO + ' ' + TEN HOTEN FROM (
	SELECT MAHV, COUNT(KQUA) SODAT FROM KETQUATHI A
	WHERE NOT EXISTS (
		SELECT 1 FROM KETQUATHI B 
		WHERE A.MAHV = B.MAHV AND A.MAMH = B.MAMH AND A.LANTHI < B.LANTHI
	) AND KQUA = 'Dat'
	GROUP BY MAHV
	INTERSECT
	SELECT MAHV, COUNT(MAMH) SOMH FROM KETQUATHI 
	WHERE LANTHI = 1
	GROUP BY MAHV
) C INNER JOIN HOCVIEN HV
ON C.MAHV = HV.MAHV
GO

-- 35.	** Tìm học viên (mã học viên, họ tên) có điểm thi cao nhất trong từng môn (lấy điểm ở lần thi sau cùng).
SELECT A.MAHV, HO + ' ' + TEN HOTEN FROM (
	SELECT B.MAMH, MAHV, DIEM, DIEMMAX
	FROM KETQUATHI B INNER JOIN (
		SELECT MAMH, MAX(DIEM) DIEMMAX FROM KETQUATHI
		GROUP BY MAMH
	) C 
	ON B.MAMH = C.MAMH
	WHERE NOT EXISTS (
		SELECT 1 FROM KETQUATHI D 
		WHERE B.MAHV = D.MAHV AND B.MAMH = D.MAMH AND B.LANTHI < D.LANTHI
	) AND DIEM = DIEMMAX
) A INNER JOIN HOCVIEN HV
ON A.MAHV = HV.MAHV
GO