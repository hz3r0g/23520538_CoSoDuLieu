USE QUANLYCONGTY
GO

-- 76. Liệt kê top 3 chuyên gia có nhiều kỹ năng nhất và số lượng kỹ năng của họ.
SELECT TOP 3 ChuyenGia.MaChuyenGia, ChuyenGia.HoTen, COUNT(ChuyenGia_KyNang.MaKyNang) AS SoLuongKyNang
FROM ChuyenGia
JOIN ChuyenGia_KyNang ON ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
GROUP BY ChuyenGia.MaChuyenGia, ChuyenGia.HoTen
ORDER BY SoLuongKyNang DESC;
GO

-- 77. Tìm các cặp chuyên gia có cùng chuyên ngành và số năm kinh nghiệm chênh lệch không quá 2 năm.
SELECT A.HoTen AS ChuyenGia1, B.HoTen AS ChuyenGia2, A.ChuyenNganh, ABS(A.NamKinhNghiem - B.NamKinhNghiem) AS ChenhLechNam
FROM ChuyenGia A, ChuyenGia B
WHERE A.MaChuyenGia < B.MaChuyenGia 
  AND A.ChuyenNganh = B.ChuyenNganh
  AND ABS(A.NamKinhNghiem - B.NamKinhNghiem) <= 2;
GO

-- 78. Hiển thị tên công ty, số lượng dự án và tổng số năm kinh nghiệm của các chuyên gia tham gia dự án của công ty đó.
SELECT CongTy.TenCongTy, COUNT(DuAn.MaDuAn) AS SoLuongDuAn, SUM(ChuyenGia.NamKinhNghiem) AS TongNamKinhNghiem
FROM CongTy
JOIN DuAn ON CongTy.MaCongTy = DuAn.MaCongTy
JOIN ChuyenGia_DuAn ON DuAn.MaDuAn = ChuyenGia_DuAn.MaDuAn
JOIN ChuyenGia ON ChuyenGia_DuAn.MaChuyenGia = ChuyenGia.MaChuyenGia
GROUP BY CongTy.TenCongTy;
GO

-- 79. Tìm các chuyên gia có ít nhất một kỹ năng cấp độ 5 nhưng không có kỹ năng nào dưới cấp độ 3.
SELECT DISTINCT ChuyenGia.HoTen
FROM ChuyenGia
JOIN ChuyenGia_KyNang ON ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
GROUP BY ChuyenGia.MaChuyenGia, ChuyenGia.HoTen
HAVING MAX(ChuyenGia_KyNang.CapDo) = 5 AND MIN(ChuyenGia_KyNang.CapDo) >= 3;
GO

-- 80. Liệt kê các chuyên gia và số lượng dự án họ tham gia, bao gồm cả những chuyên gia không tham gia dự án nào.
SELECT ChuyenGia.HoTen, COUNT(ChuyenGia_DuAn.MaDuAn) AS SoLuongDuAn
FROM ChuyenGia
LEFT JOIN ChuyenGia_DuAn ON ChuyenGia.MaChuyenGia = ChuyenGia_DuAn.MaChuyenGia
GROUP BY ChuyenGia.HoTen;
GO

-- 81*. Tìm chuyên gia có kỹ năng ở cấp độ cao nhất trong mỗi loại kỹ năng.
SELECT K.TenKyNang, C.HoTen, CK.CapDo
FROM KyNang K
JOIN ChuyenGia_KyNang CK ON K.MaKyNang = CK.MaKyNang
JOIN ChuyenGia C ON CK.MaChuyenGia = C.MaChuyenGia
JOIN (
    SELECT MaKyNang, MAX(CapDo) AS MaxCapDo
    FROM ChuyenGia_KyNang
    GROUP BY MaKyNang
) AS MaxLevel ON CK.MaKyNang = MaxLevel.MaKyNang AND CK.CapDo = MaxLevel.MaxCapDo;
GO

-- 82. Tính tỷ lệ phần trăm của mỗi chuyên ngành trong tổng số chuyên gia.
SELECT ChuyenNganh, 
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM ChuyenGia), 2) AS TiLePhanTram
FROM ChuyenGia
GROUP BY ChuyenNganh;
GO

-- 83. Tìm các cặp kỹ năng thường xuất hiện cùng nhau nhất trong hồ sơ của các chuyên gia.
SELECT K1.TenKyNang AS KyNang1, K2.TenKyNang AS KyNang2, COUNT(*) AS SoLanXuatHien
FROM ChuyenGia_KyNang AS CK1
JOIN ChuyenGia_KyNang AS CK2 ON CK1.MaChuyenGia = CK2.MaChuyenGia AND CK1.MaKyNang < CK2.MaKyNang
JOIN KyNang AS K1 ON CK1.MaKyNang = K1.MaKyNang
JOIN KyNang AS K2 ON CK2.MaKyNang = K2.MaKyNang
GROUP BY K1.TenKyNang, K2.TenKyNang
ORDER BY SoLanXuatHien DESC;
GO

-- 84. Tính số ngày trung bình giữa ngày bắt đầu và ngày kết thúc của các dự án cho mỗi công ty.
SELECT CongTy.TenCongTy, AVG(DATEDIFF(day, DuAn.NgayBatDau, DuAn.NgayKetThuc)) AS SoNgayTrungBinh
FROM CongTy
JOIN DuAn ON CongTy.MaCongTy = DuAn.MaCongTy
GROUP BY CongTy.TenCongTy;
GO

-- 85*. Tìm chuyên gia có sự kết hợp độc đáo nhất của các kỹ năng (kỹ năng mà chỉ họ có).
SELECT ChuyenGia.HoTen, COUNT(DISTINCT ChuyenGia_KyNang.MaKyNang) AS SoLuongKyNang
FROM ChuyenGia
JOIN ChuyenGia_KyNang ON ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
GROUP BY ChuyenGia.MaChuyenGia, ChuyenGia.HoTen
HAVING COUNT(DISTINCT ChuyenGia_KyNang.MaKyNang) = 1;
GO

-- 86*. Tạo một bảng xếp hạng các chuyên gia dựa trên số lượng dự án và tổng cấp độ kỹ năng.
SELECT ChuyenGia.HoTen, COUNT(ChuyenGia_DuAn.MaDuAn) AS SoLuongDuAn, SUM(ChuyenGia_KyNang.CapDo) AS TongCapDo,
       ROW_NUMBER() OVER (ORDER BY COUNT(ChuyenGia_DuAn.MaDuAn) DESC, SUM(ChuyenGia_KyNang.CapDo) DESC) AS XepHang
FROM ChuyenGia
LEFT JOIN ChuyenGia_DuAn ON ChuyenGia.MaChuyenGia = ChuyenGia_DuAn.MaChuyenGia
LEFT JOIN ChuyenGia_KyNang ON ChuyenGia.MaChuyenGia = ChuyenGia_KyNang.MaChuyenGia
GROUP BY ChuyenGia.HoTen;
GO

-- 87. Tìm các dự án có sự tham gia của chuyên gia từ tất cả các chuyên ngành.
SELECT DuAn.TenDuAn
FROM DuAn
JOIN ChuyenGia_DuAn ON DuAn.MaDuAn = ChuyenGia_DuAn.MaDuAn
JOIN ChuyenGia ON ChuyenGia_DuAn.MaChuyenGia = ChuyenGia.MaChuyenGia
GROUP BY DuAn.TenDuAn
HAVING COUNT(DISTINCT ChuyenGia.ChuyenNganh) = (SELECT COUNT(DISTINCT ChuyenNganh) FROM ChuyenGia);
GO

-- 88. Tính tỷ lệ thành công của mỗi công ty dựa trên số dự án hoàn thành so với tổng số dự án.
SELECT CongTy.TenCongTy, 
       ROUND(100.0 * SUM(CASE WHEN DuAn.TrangThai = N'Hoàn thành' THEN 1 ELSE 0 END) / COUNT(*), 2) AS TiLeThanhCong
FROM CongTy
JOIN DuAn ON CongTy.MaCongTy = DuAn.MaCongTy
GROUP BY CongTy.TenCongTy;
GO

-- 89. Tìm các chuyên gia có kỹ năng "bù trừ" nhau (một người giỏi kỹ năng A nhưng yếu kỹ năng B, người kia ngược lại).
SELECT C1.HoTen AS ChuyenGia1, C2.HoTen AS ChuyenGia2, K1.TenKyNang AS KyNang1, K2.TenKyNang AS KyNang2
FROM ChuyenGia_KyNang AS CK1
JOIN ChuyenGia_KyNang AS CK2 ON CK1.MaKyNang = CK2.MaKyNang AND CK1.CapDo >= 4 AND CK2.CapDo <= 2
JOIN ChuyenGia AS C1 ON CK1.MaChuyenGia = C1.MaChuyenGia
JOIN ChuyenGia AS C2 ON CK2.MaChuyenGia = C2.MaChuyenGia
JOIN KyNang AS K1 ON CK1.MaKyNang = K1.MaKyNang
JOIN KyNang AS K2 ON CK2.MaKyNang = K2.MaKyNang
WHERE C1.MaChuyenGia < C2.MaChuyenGia;
GO