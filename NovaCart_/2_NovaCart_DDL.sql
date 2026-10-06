

IF DB_ID(N'NovaCartDB') IS NOT NULL
BEGIN
    ALTER DATABASE NovaCartDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE NovaCartDB;
END;
GO

CREATE DATABASE NovaCartDB;
GO

USE NovaCartDB;
GO

CREATE TABLE dbo.Customers
(
    customer_id INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Customers_CustomerId PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(255) NOT NULL
        CONSTRAINT UQ_Customers_EmailAddress UNIQUE,
    phone NVARCHAR(30) NOT NULL,
    home_address NVARCHAR(255) NOT NULL,
    join_date DATE NOT NULL
);
GO

CREATE TABLE dbo.Products
(
    product_id INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Products_ProductId PRIMARY KEY,
    name NVARCHAR(150) NOT NULL,
    category NVARCHAR(50) NOT NULL,
    price DECIMAL(12,2) NOT NULL
        CONSTRAINT CK_Products_CurrentPrice_Positive CHECK (price > 0),
    stock_quantity INT NOT NULL
        CONSTRAINT CK_Products_StockQuantity_NonNegative CHECK (stock_quantity >= 0)
);
GO

CREATE TABLE dbo.Orders
(
    order_id INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Orders_OrderId PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    status NVARCHAR(20) NOT NULL
        CONSTRAINT CK_Orders_Status_Allowed
        CHECK (status IN (N'Pending', N'Shipped', N'Delivered', N'Cancelled')),
    CONSTRAINT FK_Orders_CustomerId
        FOREIGN KEY (customer_id) REFERENCES dbo.Customers(customer_id)
);
GO

CREATE TABLE dbo.OrderDetails
(
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL
        CONSTRAINT CK_OrderDetails_Quantity_Positive CHECK (quantity > 0),
    unit_price DECIMAL(12,2) NOT NULL
        CONSTRAINT CK_OrderDetails_HistoricalUnitPrice_Positive CHECK (unit_price > 0),
    CONSTRAINT PK_OrderDetails_OrderProduct PRIMARY KEY (order_id, product_id),
    CONSTRAINT FK_OrderDetails_OrderId
        FOREIGN KEY (order_id) REFERENCES dbo.Orders(order_id),
    CONSTRAINT FK_OrderDetails_ProductId
        FOREIGN KEY (product_id) REFERENCES dbo.Products(product_id)
);
GO

CREATE TABLE dbo.Payments
(
    payment_id INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Payments_PaymentId PRIMARY KEY,
    order_id INT NOT NULL
        CONSTRAINT UQ_Payments_OrderId UNIQUE,
    payment_date DATE NOT NULL,
    amount DECIMAL(12,2) NOT NULL
        CONSTRAINT CK_Payments_Amount_Positive CHECK (amount > 0),
    method NVARCHAR(30) NOT NULL
        CONSTRAINT CK_Payments_Method_Allowed
        CHECK (method IN (N'Credit Card', N'PayPal', N'Cash on Delivery (COD)')),
    CONSTRAINT FK_Payments_OrderId
        FOREIGN KEY (order_id) REFERENCES dbo.Orders(order_id)
);
GO

CREATE TABLE dbo.Reviews
(
    review_id INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Reviews_ReviewId PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    rating TINYINT NOT NULL
        CONSTRAINT CK_Reviews_Rating_1_To_5 CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(500) NULL,
    review_date DATE NOT NULL,
    CONSTRAINT UQ_Reviews_Customer_Product UNIQUE (customer_id, product_id),
    CONSTRAINT FK_Reviews_CustomerId
        FOREIGN KEY (customer_id) REFERENCES dbo.Customers(customer_id),
    CONSTRAINT FK_Reviews_ProductId
        FOREIGN KEY (product_id) REFERENCES dbo.Products(product_id)
);
GO

/*
The review-purchase rule spans Orders and OrderDetails, so it cannot be
enforced by a simple CHECK constraint. The trigger below enforces it at
the database level: a customer may review a product only if that customer
has purchased the product in at least one order.
*/

CREATE TRIGGER dbo.TR_Reviews_PurchaseRequired
ON dbo.Reviews
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM inserted AS i
        WHERE NOT EXISTS
        (
            SELECT 1
            FROM dbo.Orders AS o
            INNER JOIN dbo.OrderDetails AS od
                ON od.order_id = o.order_id
            WHERE o.customer_id = i.customer_id
              AND od.product_id = i.product_id
        )
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50001, 'A customer can review a product only after purchasing it.', 1;
    END;
END;
GO
