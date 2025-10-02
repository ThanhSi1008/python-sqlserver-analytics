-- Nếu database tồn tại thì xóa đi để tạo lại
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'StudentDB')
BEGIN
    ALTER DATABASE StudentDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE StudentDB;
END
GO

-- Tạo database
CREATE DATABASE StudentDB;
GO

USE StudentDB;
GO

-- Bảng Students
CREATE TABLE Students (
    StudentID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    Gender NVARCHAR(10),
    BirthDate DATE,
    Email NVARCHAR(100),
    Phone NVARCHAR(20)
);
GO

-- Bảng Classes
CREATE TABLE Classes (
    ClassID INT PRIMARY KEY IDENTITY(1,1),
    ClassName NVARCHAR(50) NOT NULL,
    Department NVARCHAR(50)
);
GO

-- Bảng Courses
CREATE TABLE Courses (
    CourseID INT PRIMARY KEY IDENTITY(1,1),
    CourseName NVARCHAR(100) NOT NULL,
    Credits INT NOT NULL
);
GO

-- Bảng Enrollments (Sinh viên đăng ký học môn nào trong lớp nào)
CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
    CourseID INT FOREIGN KEY REFERENCES Courses(CourseID),
    ClassID INT FOREIGN KEY REFERENCES Classes(ClassID),
    Semester NVARCHAR(20)
);
GO

-- Bảng Grades (Điểm thi)
CREATE TABLE Grades (
    GradeID INT PRIMARY KEY IDENTITY(1,1),
    EnrollmentID INT FOREIGN KEY REFERENCES Enrollments(EnrollmentID),
    Midterm DECIMAL(5,2),
    Final DECIMAL(5,2),
    Average AS ((Midterm * 0.4) + (Final * 0.6)) PERSISTED
);
GO

-- Insert dữ liệu mẫu
INSERT INTO Students (FullName, Gender, BirthDate, Email, Phone) VALUES
(N'Nguyen Van A', N'Nam', '2002-05-12', 'vana@example.com', '0901234567'),
(N'Tran Thi B', N'Nữ', '2001-11-20', 'thib@example.com', '0912345678'),
(N'Le Van C', N'Nam', '2003-03-15', 'vanc@example.com', '0923456789'),
(N'Pham Thi D', N'Nữ', '2002-07-01', 'thid@example.com', '0934567890');
GO

INSERT INTO Classes (ClassName, Department) VALUES
(N'CNTT1', N'Công nghệ thông tin'),
(N'KT1', N'Kinh tế'),
(N'QTKD1', N'Quản trị kinh doanh');
GO

INSERT INTO Courses (CourseName, Credits) VALUES
(N'Cơ sở dữ liệu', 3),
(N'Lập trình Python', 4),
(N'Marketing căn bản', 3),
(N'Tài chính doanh nghiệp', 3),
(N'Trí tuệ nhân tạo', 4);
GO

INSERT INTO Enrollments (StudentID, CourseID, ClassID, Semester) VALUES
(1, 1, 1, N'HK1-2024'),
(1, 2, 1, N'HK1-2024'),
(2, 3, 2, N'HK1-2024'),
(2, 4, 2, N'HK1-2024'),
(3, 1, 1, N'HK1-2024'),
(3, 5, 1, N'HK2-2024'),
(4, 2, 1, N'HK1-2024'),
(4, 3, 3, N'HK2-2024');
GO

INSERT INTO Grades (EnrollmentID, Midterm, Final) VALUES
(1, 7.5, 8.0),
(2, 8.0, 9.0),
(3, 6.0, 7.0),
(4, 7.0, 6.5),
(5, 9.0, 8.5),
(6, 8.0, 9.5),
(7, 5.5, 6.0),
(8, 7.5, 7.0);
GO
