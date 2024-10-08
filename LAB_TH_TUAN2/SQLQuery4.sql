USE QUANLYGIAOVU
GO
-- 11.	Học viên ít nhất là 18 tuổi.
ALTER TABLE HOCVIEN ADD CONSTRAINT CK_TUOI CHECK(GETDATE() - NGSINH >= 18)
GO

-- 12.	Giảng dạy một môn học ngày bắt đầu (TUNGAY) phải nhỏ hơn ngày kết thúc (DENNGAY).
ALTER TABLE GIANGDAY ADD CONSTRAINT CK_NGAY CHECK(TUNGAY < DENNGAY)
GO

-- 13.	Giáo viên khi vào làm ít nhất là 22 tuổi.
ALTER TABLE GIAOVIEN ADD CONSTRAINT CK_NGVL CHECK(GETDATE() - NGVL >= 22)
GO

-- 14.	Tất cả các môn học đều có số tín chỉ lý thuyết và tín chỉ thực hành chênh lệch nhau không quá 3.
ALTER TABLE MONHOC ADD CONSTRAINT CK_TC CHECK(ABS(TCLT - TCTH) <= 3)
GO