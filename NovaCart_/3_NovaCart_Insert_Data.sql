
USE NovaCartDB;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRANSACTION;
GO

-- Customers 
INSERT INTO dbo.Customers (full_name, email, phone, home_address, join_date)
VALUES
(N'Adam Farid', N'adam.farid@example.com', N'+20-100-222-0001', N'14 Garden City St, Cairo', '2024-08-15'),
(N'Lina Mostafa', N'lina.mostafa@example.com', N'+20-100-222-0002', N'26 Dokki St, Giza', '2024-09-02'),
(N'Ziad Nasser', N'ziad.nasser@example.com', N'+20-100-222-0003', N'9 El Nasr St, Giza', '2024-09-18'),
(N'Mariam Adel', N'mariam.adel@example.com', N'+20-100-222-0004', N'33 Corniche St, Alexandria', '2024-10-05'),
(N'Omar Fathy', N'omar.fathy@example.com', N'+20-100-222-0005', N'17 Zamalek St, Cairo', '2024-10-22'),
(N'Nourhan Sami', N'nourhan.sami@example.com', N'+20-100-222-0006', N'8 Heliopolis St, Cairo', '2024-11-11'),
(N'Yassin Nabil', N'yassin.nabil@example.com', N'+20-100-222-0007', N'21 Haram St, Giza', '2024-11-28'),
(N'Salma Hany', N'salma.hany@example.com', N'+20-100-222-0008', N'46 Mansheya St, Alexandria', '2024-12-10'),
(N'Khaled Mahmoud', N'khaled.mahmoud@example.com', N'+20-100-222-0009', N'11 Maadi St, Cairo', '2025-01-06'),
(N'Dalia Ashraf', N'dalia.ashraf@example.com', N'+20-100-222-0010', N'24 Mohandessin St, Giza', '2025-01-20'),
(N'Hatem Fawzy', N'hatem.fawzy@example.com', N'+20-100-222-0011', N'13 Suez St, Ismailia', '2025-02-03'),
(N'Rania Tarek', N'rania.tarek@example.com', N'+20-100-222-0012', N'7 Canal St, Port Said', '2025-02-17');
GO

-- Products 
INSERT INTO dbo.Products (name, category, price, stock_quantity)
VALUES
(N'VisionPro 55-inch 4K TV', N'Electronics', 18500.00, 18),
(N'TechBook X15 Laptop', N'Electronics', 12800.00, 25),
(N'NovaOne Smartphone', N'Electronics', 9200.00, 40),
(N'BreezeMax Inverter AC', N'Home Appliances', 7600.00, 12),
(N'FreshWash Washing Machine', N'Home Appliances', 6800.00, 15),
(N'ClearSound Headphones', N'Accessories', 1450.00, 60),
(N'PulseFit Smart Watch', N'Accessories', 2850.00, 35),
(N'MetroCarry Backpack', N'Fashion', 850.00, 75),
(N'StreetFlex Sneakers', N'Fashion', 2400.00, 50),
(N'ReadGo E-Reader', N'Books', 4100.00, 30),
(N'ProType Mechanical Keyboard', N'Accessories', 3200.00, 45),
(N'Barista Home Espresso Maker', N'Home Appliances', 5400.00, 20),
(N'ErgoDesk Office Chair', N'Home Appliances', 6100.00, 16),
(N'BlendMaster Premium Blender', N'Home Appliances', 3900.00, 22),
(N'PureBeat Wireless Earbuds', N'Accessories', 2100.00, 70);
GO

-- Orders 
INSERT INTO dbo.Orders (customer_id, order_date, status)
VALUES
(1, '2025-01-10', N'Delivered'),
(1, '2025-01-25', N'Delivered'),
(2, '2025-02-08', N'Shipped'),
(3, '2025-02-20', N'Delivered'),
(4, '2025-03-05', N'Pending'),
(5, '2025-03-18', N'Delivered'),
(5, '2025-04-02', N'Delivered'),
(6, '2025-04-15', N'Shipped'),
(7, '2025-05-03', N'Delivered'),
(8, '2025-05-20', N'Cancelled'),
(8, '2025-06-07', N'Delivered'),
(9, '2025-06-22', N'Delivered'),
(10, '2025-07-04', N'Shipped'),
(10, '2025-07-19', N'Delivered'),
(3, '2025-08-01', N'Delivered'),
(2, '2025-08-16', N'Pending'),
(4, '2025-09-03', N'Delivered'),
(6, '2025-09-21', N'Delivered');
GO

-- OrderDetails 
INSERT INTO dbo.OrderDetails (order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 5200.00),
(1, 6, 2, 450.00),
(2, 2, 2, 3400.00),
(2, 7, 1, 280.00),
(3, 3, 1, 7200.00),
(3, 10, 1, 900.00),
(4, 4, 2, 1650.00),
(5, 5, 3, 1100.00),
(5, 8, 1, 650.00),
(6, 6, 4, 430.00),
(6, 9, 2, 1200.00),
(7, 1, 1, 5000.00),
(7, 11, 2, 750.00),
(8, 2, 1, 3300.00),
(8, 12, 1, 1500.00),
(9, 3, 1, 7000.00),
(9, 13, 2, 520.00),
(10, 4, 1, 1600.00),
(10, 10, 2, 880.00),
(11, 5, 2, 1050.00),
(11, 7, 2, 2700.00),
(12, 6, 1, 1400.00),
(12, 12, 1, 5200.00),
(13, 9, 3, 1150.00),
(14, 2, 1, 3250.00),
(14, 11, 1, 3100.00),
(15, 1, 1, 5100.00),
(15, 6, 1, 420.00),
(16, 3, 1, 7100.00),
(16, 15, 2, 1900.00),
(17, 13, 1, 5900.00),
(17, 8, 2, 600.00),
(18, 5, 1, 1080.00),
(18, 9, 1, 2300.00),
(18, 11, 1, 3000.00);
GO

-- Payments 
INSERT INTO dbo.Payments (order_id, payment_date, amount, method)
VALUES
(1, '2025-01-12', 6100.00, N'Credit Card'),
(2, '2025-01-28', 7080.00, N'PayPal'),
(3, '2025-02-12', 8100.00, N'Cash on Delivery (COD)'),
(4, '2025-02-25', 3300.00, N'Credit Card'),
(5, '2025-03-11', 3950.00, N'PayPal'),
(6, '2025-03-25', 4120.00, N'Cash on Delivery (COD)'),
(7, '2025-04-03', 6500.00, N'Credit Card'),
(8, '2025-04-17', 4800.00, N'PayPal'),
(9, '2025-05-06', 8040.00, N'Cash on Delivery (COD)'),
(10, '2025-05-24', 3360.00, N'Credit Card'),
(11, '2025-06-12', 7500.00, N'PayPal'),
(12, '2025-06-28', 6600.00, N'Cash on Delivery (COD)'),
(13, '2025-07-11', 3450.00, N'Credit Card'),
(14, '2025-07-20', 6350.00, N'PayPal'),
(15, '2025-08-03', 5520.00, N'Cash on Delivery (COD)'),
(16, '2025-08-19', 10900.00, N'Credit Card'),
(17, '2025-09-07', 7100.00, N'PayPal'),
(18, '2025-09-26', 6380.00, N'Cash on Delivery (COD)');
GO

-- Reviews 
INSERT INTO dbo.Reviews (customer_id, product_id, rating, comment, review_date)
VALUES
(1, 1, 5, N'Excellent picture quality.', '2025-01-18'),
(1, 2, 4, N'Fast and reliable laptop.', '2025-02-02'),
(1, 6, 5, N'Very comfortable headphones.', '2025-02-03'),
(2, 3, 4, N'Great performance and battery.', '2025-02-16'),
(2, 10, 3, N'Useful, but the screen is basic.', '2025-02-25'),
(2, 15, 5, N'Clear sound for the price.', '2025-08-25'),
(3, 4, 5, N'Cools the room quickly.', '2025-02-28'),
(3, 1, 4, N'Sharp image and good colors.', '2025-08-10'),
(4, 5, 3, N'Good capacity for a small family.', '2025-03-20'),
(4, 13, 5, N'Very supportive chair.', '2025-09-10'),
(5, 6, 4, N'Comfortable for long calls.', '2025-03-25'),
(5, 9, 2, N'Sizing runs a little small.', '2025-03-28'),
(5, 1, 5, N'Excellent TV for the living room.', '2025-04-10'),
(6, 2, 4, N'Good value for work.', '2025-04-20'),
(6, 12, 5, N'Makes great coffee.', '2025-05-01'),
(7, 3, 4, N'Solid phone camera.', '2025-05-15'),
(8, 5, 1, N'Delivery was fine, but the machine was noisy.', '2025-06-15'),
(8, 7, 4, N'Useful watch with a bright display.', '2025-06-20');
GO


IF (SELECT COUNT(*) FROM dbo.Customers) < 10
    THROW 50010, 'Customers data load is incomplete.', 1;
IF (SELECT COUNT(*) FROM dbo.Products) < 10
    THROW 50011, 'Products data load is incomplete.', 1;
IF (SELECT COUNT(*) FROM dbo.Orders) < 10
    THROW 50012, 'Orders data load is incomplete.', 1;
IF (SELECT COUNT(*) FROM dbo.OrderDetails) < 10
    THROW 50013, 'OrderDetails data load is incomplete.', 1;
IF (SELECT COUNT(*) FROM dbo.Payments) < 10
    THROW 50014, 'Payments data load is incomplete.', 1;
IF (SELECT COUNT(*) FROM dbo.Reviews) < 10
    THROW 50015, 'Reviews data load is incomplete.', 1;

COMMIT TRANSACTION;
GO

SELECT N'Customers' AS table_name, COUNT(*) AS row_count FROM dbo.Customers
UNION ALL
SELECT N'Products', COUNT(*) FROM dbo.Products
UNION ALL
SELECT N'Orders', COUNT(*) FROM dbo.Orders
UNION ALL
SELECT N'OrderDetails', COUNT(*) FROM dbo.OrderDetails
UNION ALL
SELECT N'Payments', COUNT(*) FROM dbo.Payments
UNION ALL
SELECT N'Reviews', COUNT(*) FROM dbo.Reviews
ORDER BY table_name;
GO
