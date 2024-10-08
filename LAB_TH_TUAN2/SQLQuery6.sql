USE QUANLYGIAOVU
GO

--BAITAP6:

-- 1.	In ra danh sách (mã học viên, họ tên, ngày sinh, mã lớp) lớp trưởng của các lớp.
SELECT HV.MAHV, HO + ' ' + TEN AS HOTEN, NGSINH, HV.MALOP 
FROM HOCVIEN HV INNER JOIN LOP 
ON HV.MAHV = LOP.TRGLOP
GO

-- 2.	In ra bảng điểm khi thi (mã học viên, họ tên , lần thi, điểm số) môn CTRR của lớp “K12”, sắp xếp theo tên, họ học viên.
SELECT KQ.MAHV, HO + ' ' + TEN AS HOTEN, LANTHI, DIEM 
FROM KETQUATHI KQ INNER JOIN HOCVIEN HV 
ON KQ.MAHV = HV.MAHV
WHERE LEFT(KQ.MAHV, 3) = 'K12' AND MAMH = 'CTRR'
ORDER BY TEN, HO
GO

-- 3.	In ra danh sách những học viên (mã học viên, họ tên) và những môn học mà học viên đó thi lần thứ nhất đã đạt.
SELECT KQ.MAHV, HO + ' ' + TEN AS HOTEN, MAMH
FROM KETQUATHI KQ INNER JOIN HOCVIEN HV 
ON KQ.MAHV = HV.MAHV
GROUP BY KQ.MAHV, HO, TEN, MAMH, KQUA
HAVING MAX(LANTHI) = 1 AND KQUA ='DAT'
ORDER BY KQ.MAHV
GO

-- 4.	In ra danh sách học viên (mã học viên, họ tên) của lớp “K11” thi môn CTRR không đạt (ở lần thi 1).
SELECT KQ.MAHV, HO + ' ' + TEN AS HOTEN
FROM KETQUATHI KQ INNER JOIN HOCVIEN HV 
ON KQ.MAHV = HV.MAHV
WHERE LEFT(KQ.MAHV, 3) = 'K11' AND MAMH = 'CTRR' AND LANTHI = 1 AND KQUA = 'Khong Dat'
GO

-- 5.	* Danh sách học viên (mã học viên, họ tên) của lớp “K” thi môn CTRR không đạt (ở tất cả các lần thi).
SELECT A.MAHV, HOTEN FROM (
	SELECT KQ.MAHV, HO + ' ' + TEN AS HOTEN, LANTHI
	FROM KETQUATHI KQ INNER JOIN HOCVIEN HV 
	ON KQ.MAHV = HV.MAHV
	WHERE LEFT(KQ.MAHV, 3) = 'K11' AND MAMH = 'CTRR' AND KQUA = 'Khong Dat'
) A 
INNER JOIN (
	SELECT MAHV, MAX(LANTHI) LANTHIMAX FROM KETQUATHI 
	WHERE LEFT(MAHV, 3) = 'K11' AND MAMH = 'CTRR'
	GROUP BY MAHV, MAMH 
) B 
ON A.MAHV = B.MAHV
WHERE LANTHI = LANTHIMAX
GO
