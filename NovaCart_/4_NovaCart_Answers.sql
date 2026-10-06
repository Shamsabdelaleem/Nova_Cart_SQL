

USE NovaCartDB;
GO


-- M1-Q1: Display all customers.
SELECT
    cust.customer_id,
    cust.full_name,
    cust.email,
    cust.phone,
    cust.home_address,
    cust.join_date
FROM dbo.Customers AS cust
ORDER BY cust.customer_id;
GO

-- M1-Q2: Display product name, category, and current price.
SELECT
    prod.name AS product_name,
    prod.category,
    prod.price AS current_price
FROM dbo.Products AS prod
ORDER BY prod.product_id;
GO

-- M1-Q3: Products whose current price is greater than 5000.
SELECT
    prod.product_id,
    prod.name AS product_name,
    prod.category,
    prod.price AS current_price
FROM dbo.Products AS prod
WHERE prod.price > 5000
ORDER BY prod.price DESC;
GO

-- M1-Q4: Customers ordered by join date, newest first.
SELECT
    cust.customer_id,
    cust.full_name,
    cust.email,
    cust.join_date
FROM dbo.Customers AS cust
ORDER BY cust.join_date DESC;
GO

-- M1-Q5: Total number of customers.
SELECT COUNT(*) AS total_customers
FROM dbo.Customers;
GO


-- M2-Q1: Average current product price.
SELECT
    AVG(prod.price) AS average_current_price
FROM dbo.Products AS prod;
GO

-- M2-Q2: Highest and lowest current product prices.
SELECT
    MAX(prod.price) AS highest_current_price,
    MIN(prod.price) AS lowest_current_price
FROM dbo.Products AS prod;
GO

-- M2-Q3: Total available stock quantity.
SELECT
    SUM(prod.stock_quantity) AS total_available_stock
FROM dbo.Products AS prod;
GO

-- M2-Q4: Total amount recorded in Payments.
SELECT
    SUM(pay.amount) AS total_payment_amount
FROM dbo.Payments AS pay;
GO

-- M2-Q5: Number of orders for each order status.
SELECT
    ord.status,
    COUNT(*) AS order_count
FROM dbo.Orders AS ord
GROUP BY ord.status
ORDER BY ord.status;
GO

-- M2-Q6: Total payment amount for each payment method.
SELECT
    pay.method AS payment_method,
    SUM(pay.amount) AS total_payment_amount
FROM dbo.Payments AS pay
GROUP BY pay.method
ORDER BY pay.method;
GO


-- M3-Q1: Total sales amount for each order.
SELECT
    detail.order_id,
    SUM(detail.quantity * detail.unit_price) AS total_sales_amount
FROM dbo.OrderDetails AS detail
GROUP BY detail.order_id
ORDER BY detail.order_id;
GO

-- M3-Q2: Orders whose total sales exceed 5000.
SELECT
    detail.order_id,
    SUM(detail.quantity * detail.unit_price) AS total_sales_amount
FROM dbo.OrderDetails AS detail
GROUP BY detail.order_id
HAVING SUM(detail.quantity * detail.unit_price) > 5000
ORDER BY total_sales_amount DESC;
GO

-- M3-Q3: Each order with customer name, date, and status.
SELECT
    ord.order_id,
    cust.full_name AS customer_name,
    ord.order_date,
    ord.status
FROM dbo.Orders AS ord
INNER JOIN dbo.Customers AS cust
    ON cust.customer_id = ord.customer_id
ORDER BY ord.order_id;
GO

-- M3-Q4: Each order with products, quantities, and historical unit prices.
SELECT
    ord.order_id,
    prod.name AS product_name,
    detail.quantity AS purchased_quantity,
    detail.unit_price AS historical_unit_price
FROM dbo.Orders AS ord
INNER JOIN dbo.OrderDetails AS detail
    ON detail.order_id = ord.order_id
INNER JOIN dbo.Products AS prod
    ON prod.product_id = detail.product_id
ORDER BY ord.order_id, prod.name;
GO

-- M3-Q5: Total amount spent by each customer.
SELECT
    cust.customer_id,
    cust.full_name AS customer_name,
    SUM(pay.amount) AS total_amount_spent
FROM dbo.Customers AS cust
INNER JOIN dbo.Orders AS ord
    ON ord.customer_id = cust.customer_id
INNER JOIN dbo.Payments AS pay
    ON pay.order_id = ord.order_id
GROUP BY cust.customer_id, cust.full_name
ORDER BY total_amount_spent DESC;
GO


-- M4-Q1: Number of reviews received by each product, including zero-review products.
SELECT
    prod.product_id,
    prod.name AS product_name,
    COUNT(rev.review_id) AS review_count
FROM dbo.Products AS prod
LEFT JOIN dbo.Reviews AS rev
    ON rev.product_id = prod.product_id
GROUP BY prod.product_id, prod.name
ORDER BY prod.product_id;
GO

-- M4-Q2: All reviews with customer name and product name.
SELECT
    rev.review_id,
    cust.full_name AS customer_name,
    prod.name AS product_name,
    rev.rating,
    rev.comment,
    rev.review_date
FROM dbo.Reviews AS rev
INNER JOIN dbo.Customers AS cust
    ON cust.customer_id = rev.customer_id
INNER JOIN dbo.Products AS prod
    ON prod.product_id = rev.product_id
ORDER BY rev.review_id;
GO

-- M4-Q3: Customers who have placed at least one order.
SELECT
    cust.customer_id,
    cust.full_name,
    cust.email
FROM dbo.Customers AS cust
WHERE EXISTS
(
    SELECT 1
    FROM dbo.Orders AS ord
    WHERE ord.customer_id = cust.customer_id
)
ORDER BY cust.customer_id;
GO

-- M4-Q4: Products that have never been ordered.
SELECT
    prod.product_id,
    prod.name AS product_name,
    prod.category,
    prod.price
FROM dbo.Products AS prod
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.OrderDetails AS detail
    WHERE detail.product_id = prod.product_id
)
ORDER BY prod.product_id;
GO

-- M4-Q5: Products that have never received a review.
SELECT
    prod.product_id,
    prod.name AS product_name,
    prod.category
FROM dbo.Products AS prod
WHERE NOT EXISTS
(
    SELECT 1
    FROM dbo.Reviews AS rev
    WHERE rev.product_id = prod.product_id
)
ORDER BY prod.product_id;
GO

-- M4-Q6: All customers and their number of orders, including zero-order customers.
SELECT
    cust.customer_id,
    cust.full_name AS customer_name,
    COUNT(ord.order_id) AS order_count
FROM dbo.Customers AS cust
LEFT JOIN dbo.Orders AS ord
    ON ord.customer_id = cust.customer_id
GROUP BY cust.customer_id, cust.full_name
ORDER BY cust.customer_id;
GO


-- M5-Q1: Customers with more orders than the average among ordering customers.
SELECT
    cust.customer_id,
    cust.full_name AS customer_name,
    COUNT(ord.order_id) AS order_count
FROM dbo.Customers AS cust
INNER JOIN dbo.Orders AS ord
    ON ord.customer_id = cust.customer_id
GROUP BY cust.customer_id, cust.full_name
HAVING COUNT(ord.order_id) >
(
    SELECT AVG(CAST(customer_order_counts.order_count AS DECIMAL(10,2)))
    FROM
    (
        SELECT
            ord2.customer_id,
            COUNT(*) AS order_count
        FROM dbo.Orders AS ord2
        GROUP BY ord2.customer_id
    ) AS customer_order_counts
)
ORDER BY order_count DESC;
GO

-- M5-Q2: Products whose current price is above the average current price.
SELECT
    prod.product_id,
    prod.name AS product_name,
    prod.category,
    prod.price AS current_price
FROM dbo.Products AS prod
WHERE prod.price >
(
    SELECT AVG(prod2.price)
    FROM dbo.Products AS prod2
)
ORDER BY prod.price DESC;
GO

-- M5-Q3: Customers whose total spending exceeds the average total spending.
SELECT
    cust.customer_id,
    cust.full_name AS customer_name,
    SUM(pay.amount) AS total_spending
FROM dbo.Customers AS cust
INNER JOIN dbo.Orders AS ord
    ON ord.customer_id = cust.customer_id
INNER JOIN dbo.Payments AS pay
    ON pay.order_id = ord.order_id
GROUP BY cust.customer_id, cust.full_name
HAVING SUM(pay.amount) >
(
    SELECT AVG(customer_totals.total_spending)
    FROM
    (
        SELECT
            ord2.customer_id,
            SUM(pay2.amount) AS total_spending
        FROM dbo.Orders AS ord2
        INNER JOIN dbo.Payments AS pay2
            ON pay2.order_id = ord2.order_id
        GROUP BY ord2.customer_id
    ) AS customer_totals
)
ORDER BY total_spending DESC;
GO


-- M6-Q1: Using a CTE, calculate total revenue by month.
WITH MonthlyRevenue AS
(
    SELECT
        DATEFROMPARTS(YEAR(pay.payment_date), MONTH(pay.payment_date), 1) AS revenue_month,
        SUM(pay.amount) AS total_revenue
    FROM dbo.Payments AS pay
    GROUP BY DATEFROMPARTS(YEAR(pay.payment_date), MONTH(pay.payment_date), 1)
)
SELECT
    revenue_month,
    total_revenue
FROM MonthlyRevenue
ORDER BY revenue_month;
GO

-- M6-Q2: Using a CTE, calculate customer spending and return only customers above 10000.
WITH CustomerSpending AS
(
    SELECT
        cust.customer_id,
        cust.full_name AS customer_name,
        SUM(pay.amount) AS total_spent
    FROM dbo.Customers AS cust
    INNER JOIN dbo.Orders AS ord
        ON ord.customer_id = cust.customer_id
    INNER JOIN dbo.Payments AS pay
        ON pay.order_id = ord.order_id
    GROUP BY cust.customer_id, cust.full_name
)
SELECT
    customer_id,
    customer_name,
    total_spent
FROM CustomerSpending
WHERE total_spent > 10000
ORDER BY total_spent DESC;
GO

-- M6-Q3: Customers whose spending is above the average spending among paying customers.
WITH CustomerSpending AS
(
    SELECT
        cust.customer_id,
        cust.full_name AS customer_name,
        SUM(pay.amount) AS total_spending
    FROM dbo.Customers AS cust
    INNER JOIN dbo.Orders AS ord
        ON ord.customer_id = cust.customer_id
    INNER JOIN dbo.Payments AS pay
        ON pay.order_id = ord.order_id
    GROUP BY cust.customer_id, cust.full_name
),
AverageSpending AS
(
    SELECT AVG(total_spending) AS average_spending
    FROM CustomerSpending
)
SELECT
    spend.customer_id,
    spend.customer_name,
    spend.total_spending
FROM CustomerSpending AS spend
CROSS JOIN AverageSpending AS avg_spend
WHERE spend.total_spending > avg_spend.average_spending
ORDER BY spend.total_spending DESC;
GO


-- M7-Q1: Rank customers by total spending using RANK().
SELECT
    cust.customer_id,
    cust.full_name AS customer_name,
    SUM(pay.amount) AS total_spending,
    RANK() OVER (ORDER BY SUM(pay.amount) DESC) AS spending_rank
FROM dbo.Customers AS cust
INNER JOIN dbo.Orders AS ord
    ON ord.customer_id = cust.customer_id
INNER JOIN dbo.Payments AS pay
    ON pay.order_id = ord.order_id
GROUP BY cust.customer_id, cust.full_name
ORDER BY spending_rank, cust.customer_id;
GO

-- M7-Q2: Rank products by total quantity sold using DENSE_RANK().
SELECT
    prod.product_id,
    prod.name AS product_name,
    SUM(detail.quantity) AS total_quantity_sold,
    DENSE_RANK() OVER (ORDER BY SUM(detail.quantity) DESC) AS quantity_rank
FROM dbo.Products AS prod
INNER JOIN dbo.OrderDetails AS detail
    ON detail.product_id = prod.product_id
GROUP BY prod.product_id, prod.name
ORDER BY quantity_rank, prod.product_id;
GO

-- M7-Q3: Previous payment amount using LAG().
SELECT
    pay.payment_id,
    pay.payment_date,
    pay.order_id,
    pay.amount,
    LAG(pay.amount) OVER
    (
        ORDER BY pay.payment_date, pay.payment_id
    ) AS previous_payment_amount
FROM dbo.Payments AS pay
ORDER BY pay.payment_date, pay.payment_id;
GO

-- M7-Q4: Running total of payment amounts.
SELECT
    pay.payment_id,
    pay.payment_date,
    pay.order_id,
    pay.amount,
    SUM(pay.amount) OVER
    (
        ORDER BY pay.payment_date, pay.payment_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM dbo.Payments AS pay
ORDER BY pay.payment_date, pay.payment_id;
GO


-- M8-Q1: Create monthly revenue view.
CREATE VIEW dbo.vw_revenue_by_month
AS
SELECT
    DATEFROMPARTS(YEAR(pay.payment_date), MONTH(pay.payment_date), 1) AS revenue_month,
    SUM(pay.amount) AS total_revenue
FROM dbo.Payments AS pay
GROUP BY DATEFROMPARTS(YEAR(pay.payment_date), MONTH(pay.payment_date), 1);
GO

-- M8-Q2: Create best-selling products view.
CREATE VIEW dbo.vw_best_selling_products
AS
SELECT
    prod.product_id,
    prod.name AS product_name,
    SUM(detail.quantity) AS total_quantity_sold,
    SUM(detail.quantity * detail.unit_price) AS total_revenue
FROM dbo.Products AS prod
INNER JOIN dbo.OrderDetails AS detail
    ON detail.product_id = prod.product_id
GROUP BY prod.product_id, prod.name;
GO

-- M8-Q3: Create customer summary view.
CREATE VIEW dbo.vw_customer_summary
AS
SELECT
    cust.customer_id,
    cust.full_name AS customer_name,
    COUNT(DISTINCT ord.order_id) AS number_of_orders,
    COALESCE(SUM(pay.amount), 0.00) AS total_amount_spent
FROM dbo.Customers AS cust
LEFT JOIN dbo.Orders AS ord
    ON ord.customer_id = cust.customer_id
LEFT JOIN dbo.Payments AS pay
    ON pay.order_id = ord.order_id
GROUP BY cust.customer_id, cust.full_name;
GO


SELECT *
FROM dbo.vw_revenue_by_month
ORDER BY revenue_month;
GO

SELECT *
FROM dbo.vw_best_selling_products
ORDER BY total_quantity_sold DESC, product_name;
GO

SELECT *
FROM dbo.vw_customer_summary
ORDER BY customer_id;
GO
