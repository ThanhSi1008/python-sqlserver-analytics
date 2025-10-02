IF EXISTS (SELECT name FROM sys.databases WHERE name = N'ShopDB')
BEGIN
    ALTER DATABASE ShopDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE ShopDB;
END
GO

CREATE DATABASE ShopDB;
GO

USE ShopDB;
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Customers' AND xtype='U')
BEGIN
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName NVARCHAR(100),
    City NVARCHAR(50),
    JoinDate DATE
);
END
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Products' AND xtype='U')
BEGIN
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    Price DECIMAL(10,2)
);
END
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Orders' AND xtype='U')
BEGIN
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    OrderDate DATE
);
END
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='OrderDetails' AND xtype='U')
BEGIN
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT
);
END
GO

-- Insert Customers
IF NOT EXISTS (SELECT 1 FROM Customers)
BEGIN
INSERT INTO Customers (CustomerName, City, JoinDate) VALUES
('Alice Nguyen', 'Hanoi', '2024-01-15'),
('Bob Tran', 'Ho Chi Minh', '2024-02-10'),
('Charlie Le', 'Da Nang', '2024-03-05'),
('David Pham', 'Hanoi', '2024-04-12'),
('Eva Hoang', 'Ho Chi Minh', '2024-05-20'),
('Frank Vu', 'Da Nang', '2024-06-18'),
('Grace Phan', 'Hanoi', '2024-07-01'),
('Henry Bui', 'Ho Chi Minh', '2024-07-15'),
('Ivy Ngo', 'Da Nang', '2024-08-05'),
('Jack Lam', 'Hanoi', '2024-08-20');
END
GO

-- Insert Products
IF NOT EXISTS (SELECT 1 FROM Products)
BEGIN
INSERT INTO Products (ProductName, Category, Price) VALUES
('Laptop Pro 15', 'Electronics', 1200.00),
('Wireless Mouse', 'Electronics', 25.00),
('Office Chair', 'Furniture', 150.00),
('Water Bottle', 'Lifestyle', 12.00),
('Standing Desk', 'Furniture', 350.00),
('Keyboard Mechanical', 'Electronics', 80.00),
('Desk Lamp', 'Furniture', 45.00),
('Notebook', 'Lifestyle', 5.00),
('Monitor 27 inch', 'Electronics', 300.00),
('Backpack', 'Lifestyle', 40.00);
END
GO

-- Insert Orders
IF NOT EXISTS (SELECT 1 FROM Orders)
BEGIN
INSERT INTO Orders (CustomerID, OrderDate) VALUES
(1, '2024-09-01'),
(2, '2024-09-02'),
(3, '2024-09-03'),
(1, '2024-09-05'),
(2, '2024-09-07'),
(4, '2024-09-08'),
(5, '2024-09-09'),
(6, '2024-09-10'),
(3, '2024-09-11'),
(1, '2024-09-12'),
(7, '2024-09-13'),
(8, '2024-09-14'),
(9, '2024-09-15'),
(10, '2024-09-16');
END
GO

-- Insert OrderDetails
IF NOT EXISTS (SELECT 1 FROM OrderDetails)
BEGIN
INSERT INTO OrderDetails (OrderID, ProductID, Quantity) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 1),
(3, 4, 3),
(4, 5, 1),
(5, 2, 5),
(6, 6, 1),
(6, 7, 2),
(7, 1, 1),
(7, 4, 1),
(8, 5, 2),
(9, 8, 10),
(10, 2, 1),
(10, 6, 1),
(11, 9, 1),
(11, 10, 2),
(12, 1, 2),
(12, 3, 1),
(13, 4, 2),
(13, 7, 1),
(14, 5, 1),
(14, 8, 2);
END
GO