IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'ShopDB')
BEGIN
    CREATE DATABASE ShopDB;
END
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

IF NOT EXISTS (SELECT 1 FROM Customers)
BEGIN
INSERT INTO Customers (CustomerName, City, JoinDate) VALUES
('Alice Nguyen', 'Hanoi', '2024-01-15'),
('Bob Tran', 'Ho Chi Minh', '2024-02-10'),
('Charlie Le', 'Da Nang', '2024-03-05');
END
GO

IF NOT EXISTS (SELECT 1 FROM Products)
BEGIN
INSERT INTO Products (ProductName, Category, Price) VALUES
('Laptop Pro 15', 'Electronics', 1200.00),
('Wireless Mouse', 'Electronics', 25.00),
('Office Chair', 'Furniture', 150.00),
('Water Bottle', 'Lifestyle', 12.00),
('Standing Desk', 'Furniture', 350.00);
END
GO

IF NOT EXISTS (SELECT 1 FROM Orders)
BEGIN
INSERT INTO Orders (CustomerID, OrderDate) VALUES
(1, '2024-09-01'),
(2, '2024-09-02'),
(3, '2024-09-03'),
(1, '2024-09-05'),
(2, '2024-09-07');
END
GO

IF NOT EXISTS (SELECT 1 FROM OrderDetails)
BEGIN
INSERT INTO OrderDetails (OrderID, ProductID, Quantity) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 1),
(3, 4, 3),
(4, 5, 1),
(5, 2, 5);
END
GO