USE QUANLYCONGTY
GO

-- 8. Hiển thị tên và cấp độ của tất cả các kỹ năng của chuyên gia có MaChuyenGia là 1.
SELECT k.TenKyNang, c.CapDo
FROM ChuyenGia_KyNang c
JOIN KyNang k ON c.MaKyNang = k.MaKyNang
WHERE c.MaChuyenGia = 1

-- 9. Liệt kê tên các chuyên gia tham gia dự án có MaDuAn là 2.
SELECT cg.HoTen
FROM ChuyenGia_DuAn cgd
JOIN ChuyenGia cg ON cgd.MaChuyenGia = cg.MaChuyenGia
WHERE cgd.MaDuAn = 2

-- 10. Hiển thị tên công ty và tên dự án của tất cả các dự án.
SELECT ct.TenCongTy, da.TenDuAn
FROM DuAn da
JOIN CongTy ct ON da.MaCongTy = ct.MaCongTy

-- 11. Đếm số lượng chuyên gia trong mỗi chuyên ngành.
SELECT ChuyenNganh, COUNT(*) AS SoLuongChuyenGia
FROM ChuyenGia
GROUP BY ChuyenNganh

-- 12. Tìm chuyên gia có số năm kinh nghiệm cao nhất.
SELECT TOP 1 HoTen, NamKinhNghiem
FROM ChuyenGia
ORDER BY NamKinhNghiem DESC

-- 13. Liệt kê tên các chuyên gia và số lượng dự án họ tham gia.
SELECT cg.HoTen, COUNT(cgd.MaDuAn) AS SoLuongDuAn
FROM ChuyenGia cg
LEFT JOIN ChuyenGia_DuAn cgd ON cg.MaChuyenGia = cgd.MaChuyenGia
GROUP BY cg.HoTen

-- 14. Hiển thị tên công ty và số lượng dự án của mỗi công ty.
SELECT ct.TenCongTy, COUNT(da.MaDuAn) AS SoLuongDuAn
FROM CongTy ct
LEFT JOIN DuAn da ON ct.MaCongTy = da.MaCongTy
GROUP BY ct.TenCongTy

-- 15. Tìm kỹ năng được sở hữu bởi nhiều chuyên gia nhất.
SELECT k.TenKyNang, COUNT(ck.MaChuyenGia) AS SoLuongChuyenGia
FROM ChuyenGia_KyNang ck
JOIN KyNang k ON ck.MaKyNang = k.MaKyNang
GROUP BY k.TenKyNang
ORDER BY SoLuongChuyenGia DESC

-- 16. Liệt kê tên các chuyên gia có kỹ năng 'Python' với cấp độ từ 4 trở lên.
SELECT cg.HoTen
FROM ChuyenGia_KyNang ck
JOIN ChuyenGia cg ON ck.MaChuyenGia = cg.MaChuyenGia
JOIN KyNang k ON ck.MaKyNang = k.MaKyNang
WHERE k.TenKyNang = 'Python' AND ck.CapDo >= 4

-- 17. Tìm dự án có nhiều chuyên gia tham gia nhất.
SELECT da.TenDuAn, COUNT(cgd.MaChuyenGia) AS SoLuongChuyenGia
FROM DuAn da
JOIN ChuyenGia_DuAn cgd ON da.MaDuAn = cgd.MaDuAn
GROUP BY da.TenDuAn
ORDER BY SoLuongChuyenGia DESC

-- 18. Hiển thị tên và số lượng kỹ năng của mỗi chuyên gia.
SELECT cg.HoTen, COUNT(ck.MaKyNang) AS SoLuongKyNang
FROM ChuyenGia cg
JOIN ChuyenGia_KyNang ck ON cg.MaChuyenGia = ck.MaChuyenGia
GROUP BY cg.HoTen

-- 19. Tìm các cặp chuyên gia làm việc cùng dự án.
SELECT c1.HoTen AS ChuyenGia1, c2.HoTen AS ChuyenGia2, da.TenDuAn
FROM ChuyenGia_DuAn cgd1
JOIN ChuyenGia_DuAn cgd2 ON cgd1.MaDuAn = cgd2.MaDuAn AND cgd1.MaChuyenGia < cgd2.MaChuyenGia
JOIN ChuyenGia c1 ON cgd1.MaChuyenGia = c1.MaChuyenGia
JOIN ChuyenGia c2 ON cgd2.MaChuyenGia = c2.MaChuyenGia
JOIN DuAn da ON cgd1.MaDuAn = da.MaDuAn

-- 20. Liệt kê tên các chuyên gia và số lượng kỹ năng cấp độ 5 của họ.
SELECT cg.HoTen, COUNT(ck.CapDo) AS SoLuongKyNangCap5
FROM ChuyenGia_KyNang ck
JOIN ChuyenGia cg ON ck.MaChuyenGia = cg.MaChuyenGia
WHERE ck.CapDo = 5
GROUP BY cg.HoTen

-- 21. Tìm các công ty không có dự án nào.
SELECT ct.TenCongTy
FROM CongTy ct
LEFT JOIN DuAn da ON ct.MaCongTy = da.MaCongTy
WHERE da.MaDuAn IS NULL

-- 22. Hiển thị tên chuyên gia và tên dự án họ tham gia, bao gồm cả chuyên gia không tham gia dự án nào.
SELECT cg.HoTen, da.TenDuAn
FROM ChuyenGia cg
LEFT JOIN ChuyenGia_DuAn cgd ON cg.MaChuyenGia = cgd.MaChuyenGia
LEFT JOIN DuAn da ON cgd.MaDuAn = da.MaDuAn

-- 23. Tìm các chuyên gia có ít nhất 3 kỹ năng.
SELECT cg.HoTen
FROM ChuyenGia_KyNang ck
JOIN ChuyenGia cg ON ck.MaChuyenGia = cg.MaChuyenGia
GROUP BY cg.HoTen
HAVING COUNT(ck.MaKyNang) >= 3

-- 24. Hiển thị tên công ty và tổng số năm kinh nghiệm của tất cả chuyên gia trong các dự án của công ty đó.
SELECT ct.TenCongTy, SUM(cg.NamKinhNghiem) AS TongSoNamKinhNghiem
FROM CongTy ct
JOIN DuAn da ON ct.MaCongTy = da.MaCongTy
JOIN ChuyenGia_DuAn cgd ON da.MaDuAn = cgd.MaDuAn
JOIN ChuyenGia cg ON cgd.MaChuyenGia = cg.MaChuyenGia
GROUP BY ct.TenCongTy

-- 25. Tìm các chuyên gia có kỹ năng 'Java' nhưng không có kỹ năng 'Python'.
SELECT cg.HoTen
FROM ChuyenGia_KyNang ck1
JOIN ChuyenGia cg ON ck1.MaChuyenGia = cg.MaChuyenGia
LEFT JOIN ChuyenGia_KyNang ck2 ON ck1.MaChuyenGia = ck2.MaChuyenGia AND ck2.MaKyNang = (
    SELECT MaKyNang FROM KyNang WHERE TenKyNang = 'Python'
)
WHERE ck1.MaKyNang = (SELECT MaKyNang FROM KyNang WHERE TenKyNang = 'Java')
AND ck2.MaKyNang IS NULL

-- 76. Tìm chuyên gia có số lượng kỹ năng nhiều nhất.
SELECT TOP 1 cg.HoTen, COUNT(ck.MaKyNang) AS SoLuongKyNang
FROM ChuyenGia_KyNang ck
JOIN ChuyenGia cg ON ck.MaChuyenGia = cg.MaChuyenGia
GROUP BY cg.HoTen
ORDER BY SoLuongKyNang DESC

-- 77. Liệt kê các cặp chuyên gia có cùng chuyên ngành.
SELECT c1.HoTen AS ChuyenGia1, c2.HoTen AS ChuyenGia2, c1.ChuyenNganh
FROM ChuyenGia c1
JOIN ChuyenGia c2 ON c1.ChuyenNganh = c2.ChuyenNganh AND c1.MaChuyenGia < c2.MaChuyenGia

-- 78. Tìm công ty có tổng số năm kinh nghiệm của các chuyên gia trong dự án cao nhất.
SELECT TOP 1 ct.TenCongTy, SUM(cg.NamKinhNghiem) AS TongSoNamKinhNghiem
FROM CongTy ct
JOIN DuAn da ON ct.MaCongTy = da.MaCongTy
JOIN ChuyenGia_DuAn cgd ON da.MaDuAn = cgd.MaDuAn
JOIN ChuyenGia cg ON cgd.MaChuyenGia = cg.MaChuyenGia
GROUP BY ct.TenCongTy
ORDER BY TongSoNamKinhNghiem DESC

-- 79. Tìm kỹ năng được sở hữu bởi tất cả các chuyên gia.
SELECT k.TenKyNang
FROM KyNang k
JOIN ChuyenGia_KyNang ck ON k.MaKyNang = ck.MaKyNang
GROUP BY k.TenKyNang
HAVING COUNT(DISTINCT ck.MaChuyenGia) = (SELECT COUNT(*) FROM ChuyenGia)
