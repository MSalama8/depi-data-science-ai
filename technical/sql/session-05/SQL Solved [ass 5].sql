-- ============================================================
-- SQL PRACTICE — 60 QUESTIONS — FINAL ANSWERS
-- PostgreSQL — Supermarket Database
-- By Eng| Mohamed Mahmoud Salama
-- ============================================================


-- ============================================================
-- LEVEL ONE - SELECT & WHERE
-- ============================================================


-- Q1: Show all the products in the products table.
SELECT * FROM products;

---------------------------------------------------------------------

-- Q2: Show only the product names and sale prices.
SELECT name, sale_price FROM products;

---------------------------------------------------------------------

-- Q3: Show the products whose sale price is greater than 30.
SELECT * FROM products WHERE sale_price > 30;

---------------------------------------------------------------------

-- Q4: Show the products whose purchase price is less than 20.
SELECT * FROM products WHERE purchase_price < 20;

---------------------------------------------------------------------

-- Q5: Show the products whose sale price is between 20 and 50.
SELECT * FROM products WHERE sale_price BETWEEN 20 AND 50;

---------------------------------------------------------------------

-- Q6: Show the products where is_active = true.
SELECT * FROM products WHERE is_active = TRUE;

---------------------------------------------------------------------

-- Q7: Show all suppliers with a balance greater than 0.
SELECT * FROM suppliers WHERE balance > 0;

---------------------------------------------------------------------

-- Q8: Show the customers who have no outstanding balance.
SELECT * FROM customers WHERE balance = 0;

---------------------------------------------------------------------

-- Q9: Show the products whose minimum stock level is greater than 20.
SELECT * FROM products WHERE min_stock > 20;

---------------------------------------------------------------------

-- Q10: Show the products whose name contains the word "Milk".
SELECT * FROM products WHERE name ILIKE '%Milk%';


-- ============================================================
-- LEVEL TWO - ORDER BY & LIMIT
-- ============================================================


-- Q11: Show the products sorted by sale price from lowest to highest.
SELECT * FROM products
ORDER BY sale_price ASC;

---------------------------------------------------------------------

-- Q12: Show the products sorted by sale price from highest to lowest.
SELECT * FROM products
ORDER BY sale_price DESC;

---------------------------------------------------------------------

-- Q13: Show the 5 most expensive products.
SELECT * FROM products
ORDER BY sale_price DESC
LIMIT 5;

---------------------------------------------------------------------

-- Q14: Show the 5 cheapest products.
SELECT * FROM products
ORDER BY sale_price ASC
LIMIT 5;

---------------------------------------------------------------------

-- Q15: Show the last 5 sales invoices by date.
SELECT * FROM sales_invoices
ORDER BY invoice_date DESC
LIMIT 5;

---------------------------------------------------------------------

-- Q16: Show the suppliers sorted by balance from highest to lowest.
SELECT * FROM suppliers
ORDER BY balance DESC;


-- ============================================================
-- LEVEL THREE - JOIN
-- ============================================================


-- Q17: Show each product name together with its category name.
SELECT p.name AS product_name, c.name AS category_name
FROM products p
JOIN categories c ON p.category_id = c.id;

---------------------------------------------------------------------

-- Q18: Show all the products that belong to the "Drinks" category.
SELECT p.*
FROM products p
JOIN categories c ON p.category_id = c.id
WHERE c.name = 'Drinks';

---------------------------------------------------------------------

-- Q19: Show all the products that belong to the "Dairy" category.
SELECT p.*
FROM products p
JOIN categories c ON p.category_id = c.id
WHERE c.name = 'Dairy';

---------------------------------------------------------------------

-- Q20: Show the purchase invoices together with the supplier name.
SELECT pi.invoice_number,
       s.name AS supplier_name,
       pi.invoice_date,
       pi.total_amount
FROM purchase_invoices pi
JOIN suppliers s ON pi.supplier_id = s.id;

---------------------------------------------------------------------

-- Q21: Show the sales invoices together with the customer name.
SELECT si.invoice_number,
       c.name AS customer_name,
       si.invoice_date,
       si.total_amount
FROM sales_invoices si
JOIN customers c ON si.customer_id = c.id;

---------------------------------------------------------------------

-- Q22: Show all sales invoices, including invoices that have no customer.
SELECT si.invoice_number,
       c.name AS customer_name,
       si.invoice_date,
       si.total_amount
FROM sales_invoices si
LEFT JOIN customers c ON si.customer_id = c.id;

---------------------------------------------------------------------

-- Q23: Show the sales invoice details (Invoice Number, Product Name, Quantity, Sale Price, Total).
SELECT si.invoice_number AS invoice_number,
       p.name            AS product_name,
       sit.quantity      AS quantity,
       sit.sale_price    AS sale_price,
       sit.total         AS total
FROM products AS p
JOIN sale_items AS sit
    ON p.id = sit.product_id
JOIN sales_invoices AS si
    ON sit.sales_invoice_id = si.id;

---------------------------------------------------------------------

-- Q24: Show the purchase invoice details (Invoice Number, Supplier Name, Product Name, Quantity, Purchase Price, Total).
SELECT pi.invoice_number AS invoice_number,
       su.name           AS supplier_name,
       p.name            AS product_name,
       pit.quantity      AS quantity,
       pit.purchase_price AS purchase_price,
       pit.total         AS total
FROM purchase_items AS pit
JOIN purchase_invoices AS pi
    ON pi.id = pit.purchase_invoice_id
JOIN suppliers AS su
    ON pi.supplier_id = su.id
JOIN products AS p
    ON p.id = pit.product_id;


-- ============================================================
-- LEVEL FOUR - AGGREGATE FUNCTIONS
-- ============================================================


-- Q25: Count the number of products in the database.
SELECT COUNT(*) AS number_of_products FROM products;

---------------------------------------------------------------------

-- Q26: Calculate the average sale price across all products.
SELECT AVG(sale_price) AS average_sale_price FROM products;

---------------------------------------------------------------------

-- Q27: Find the highest sale price.
SELECT MAX(sale_price) AS highest_sale_price FROM products;

---------------------------------------------------------------------

-- Q28: Find the lowest sale price.
SELECT MIN(sale_price) AS lowest_sale_price FROM products;

---------------------------------------------------------------------

-- Q29: Calculate the total value of all sales invoices.
SELECT SUM(total_amount) AS total_sales_value FROM sales_invoices;

---------------------------------------------------------------------

-- Q30: Calculate the total value of all purchase invoices.
SELECT SUM(total_amount) AS total_purchase_value FROM purchase_invoices;

---------------------------------------------------------------------

-- Q31: Calculate the total amount paid on sales invoices.
SELECT SUM(paid_amount) AS total_paid_amount FROM sales_invoices;

---------------------------------------------------------------------

-- Q32: Calculate the total amount still owed by customers.
SELECT SUM(balance) AS total_owed_by_customers FROM customers;

---------------------------------------------------------------------

-- Q33: Calculate the total amount still owed to suppliers.
SELECT SUM(balance) AS total_owed_to_suppliers FROM suppliers;


-- ============================================================
-- LEVEL FIVE - GROUP BY
-- ============================================================


-- Q34: Count the number of products in each category.
SELECT c.name AS category_name,
       COUNT(p.category_id) AS number_of_products
FROM categories AS c
LEFT JOIN products AS p
    ON p.category_id = c.id
GROUP BY c.name;

---------------------------------------------------------------------

-- Q35: Calculate the average sale price for each category.
SELECT c.name AS category_name,
       ROUND(AVG(p.sale_price)) AS avg_sale_price_per_category
FROM categories AS c
LEFT JOIN products AS p
    ON p.category_id = c.id
GROUP BY c.name;

---------------------------------------------------------------------

-- Q36: Find the highest sale price in each category.
SELECT c.name AS category_name,
       MAX(p.sale_price) AS max_sale_price_per_category
FROM categories AS c
LEFT JOIN products AS p
    ON p.category_id = c.id
GROUP BY c.name;

---------------------------------------------------------------------

-- Q37: Calculate the total sales for each customer.
SELECT c.id,
       c.name AS customer_name,
       COALESCE(SUM(sin.total_amount) , 0) AS total_sales
FROM customers AS c
LEFT JOIN sales_invoices AS sin
    ON sin.customer_id = c.id
GROUP BY c.id, customer_name;

---------------------------------------------------------------------

-- Q38: Count the number of sales invoices for each customer.
SELECT c.id,
       c.name AS customer_name,
       COUNT(sin.id) AS number_of_invoices
FROM customers AS c
LEFT JOIN sales_invoices AS sin
    ON sin.customer_id = c.id
GROUP BY c.id, customer_name;

---------------------------------------------------------------------

-- Q39: Calculate the total purchases from each supplier.
SELECT s.id AS supplier_id,
       s.name AS supplier_name,
       COALESCE(SUM(pin.total_amount) , 0) AS total_amount
FROM suppliers AS s
LEFT JOIN purchase_invoices AS pin
    ON s.id = pin.supplier_id
GROUP BY s.id, s.name;

---------------------------------------------------------------------

-- Q40: Count the number of purchase invoices for each supplier.
SELECT s.id AS supplier_id,
       s.name AS supplier_name,
       COUNT(pin.invoice_number) AS number_of_invoices
FROM suppliers AS s
LEFT JOIN purchase_invoices AS pin
    ON s.id = pin.supplier_id
GROUP BY s.id, s.name;

---------------------------------------------------------------------

-- Q41: Calculate the total quantity sold for each product.
SELECT p.id AS product_id,
       p.name AS product_name,
       SUM(sit.quantity) AS total_quantity
FROM products AS p
JOIN sale_items AS sit
    ON p.id = sit.product_id
GROUP BY product_id, product_name;

---------------------------------------------------------------------

-- Q42: Show the top 5 best-selling products by quantity.
SELECT p.id AS product_id,
       p.name AS product_name,
       SUM(sit.quantity) AS total_quantity
FROM products AS p
JOIN sale_items AS sit
    ON p.id = sit.product_id
GROUP BY product_id, product_name
ORDER BY total_quantity DESC
LIMIT 5;


-- ============================================================
-- LEVEL SIX - HAVING
-- ============================================================


-- Q43: Show the categories that contain more than 3 products.
SELECT c.name AS category_name,
       COUNT(p.category_id) AS number_of_products
FROM categories AS c
JOIN products AS p
    ON c.id = p.category_id
GROUP BY c.name, c.id
HAVING COUNT(p.category_id) > 3;

---------------------------------------------------------------------

-- Q44: Show the customers whose total purchases exceed 200.
SELECT cu.name AS customer_name,
       SUM(sin.total_amount) AS total_purchases
FROM customers AS cu
JOIN sales_invoices AS sin
    ON sin.customer_id = cu.id
GROUP BY cu.name, cu.id
HAVING SUM(sin.total_amount) > 200;

---------------------------------------------------------------------

-- Q45: Show the suppliers whose total purchase value exceeds 2000.
SELECT s.name AS supplier_name,
       SUM(pin.total_amount) AS total_purchases
FROM suppliers AS s
JOIN purchase_invoices AS pin
    ON s.id = pin.supplier_id
GROUP BY s.name, s.id
HAVING SUM(pin.total_amount) > 2000;

---------------------------------------------------------------------

-- Q46: Show the products that have sold more than 5 units.
SELECT p.name AS product_name,
       SUM(sit.quantity) AS number_of_units_sold
FROM products AS p
JOIN sale_items AS sit
    ON p.id = sit.product_id
GROUP BY p.name, p.id
HAVING SUM(sit.quantity) > 5;

---------------------------------------------------------------------

-- Q47: Show the categories whose average sale price is greater than 30.
SELECT c.name AS category_name,
       ROUND(AVG(p.sale_price), 2) AS average_sale_price
FROM categories AS c
JOIN products AS p
    ON c.id = p.category_id
GROUP BY c.name, c.id
HAVING ROUND(AVG(p.sale_price), 2) > 30;


-- ============================================================
-- LEVEL SEVEN - CASE STUDY
-- ============================================================


-- Q48: Which product has the highest sale price?
SELECT name AS product_name,
       sale_price AS highest_sale_price
FROM products
ORDER BY sale_price DESC
LIMIT 1;

---------------------------------------------------------------------

-- Q49: Which product has the lowest sale price?
SELECT name AS product_name,
       sale_price AS lowest_sale_price
FROM products
ORDER BY sale_price ASC
LIMIT 1;

---------------------------------------------------------------------

-- Q50: Which product has sold the most by quantity?
SELECT p.name AS product_name,
       SUM(sit.quantity) AS total_quantity_sold
FROM products AS p
JOIN sale_items AS sit
    ON sit.product_id = p.id
GROUP BY p.name, p.id
ORDER BY total_quantity_sold DESC
LIMIT 1;

---------------------------------------------------------------------

-- Q51: Which category contains the largest number of products?
SELECT c.name AS category_name,
       COUNT(p.category_id) AS number_of_products
FROM categories AS c
JOIN products AS p
    ON c.id = p.category_id
GROUP BY c.name, c.id
ORDER BY number_of_products DESC
LIMIT 1;

---------------------------------------------------------------------

-- Q52: Which customer has the highest total purchases?
SELECT cu.name AS customer_name,
       SUM(sin.total_amount) AS total_purchases
FROM customers AS cu
JOIN sales_invoices AS sin
    ON cu.id = sin.customer_id
GROUP BY cu.name, cu.id
ORDER BY total_purchases DESC
LIMIT 1;

---------------------------------------------------------------------

-- Q53: Which supplier accounts for the largest purchase value?
SELECT su.name AS supplier_name,
       SUM(pin.total_amount) AS total_purchase_value
FROM suppliers AS su
JOIN purchase_invoices AS pin
    ON su.id = pin.supplier_id
GROUP BY su.name, su.id
ORDER BY total_purchase_value DESC
LIMIT 1;

---------------------------------------------------------------------

-- Q54: What is the total value of sales on 2026-09-14?
SELECT SUM(total_amount) AS total_sales_on_date
FROM sales_invoices
-- way 1
WHERE invoice_date::date = '2026-09-14';
-- way 2
-- WHERE invoice_date >= '2026-09-14'
-- AND invoice_date < '2026-09-15';

---------------------------------------------------------------------

-- Q55: What is the total value of sales between 2026-09-10 and 2026-09-14?
SELECT SUM(total_amount) AS total_sales_in_range
FROM sales_invoices
-- way 1
WHERE invoice_date::date BETWEEN '2026-09-10' AND '2026-09-14';
-- way 2
-- WHERE invoice_date >= '2026-09-10'
-- AND invoice_date < '2026-09-15';

---------------------------------------------------------------------

-- Q56: Show the products that have been sold but whose current sale price differs from the price recorded in sale_items.
SELECT p.name AS product_name,
       p.sale_price AS current_price,
       sit.sale_price AS recorded_price
FROM products AS p
JOIN sale_items AS sit
    ON sit.product_id = p.id
WHERE p.sale_price <> sit.sale_price;

---------------------------------------------------------------------

-- Q57: Show all invoices that still have an outstanding balance.
SELECT *
FROM sales_invoices
WHERE remaining_amount > 0;

---------------------------------------------------------------------

-- Q58: Show all sales invoices that have not been paid in full.
SELECT *
FROM sales_invoices
WHERE remaining_amount > 0;

---------------------------------------------------------------------

-- Q59: Show the products that have been purchased but never sold.
SELECT DISTINCT p.*
FROM products AS p
JOIN purchase_items AS pit
    ON pit.product_id = p.id
WHERE NOT EXISTS (
    SELECT sit.id FROM sale_items AS sit WHERE sit.product_id = p.id
);

---------------------------------------------------------------------

-- Q60: Show the products that have been sold but never appear on any purchase invoice.
SELECT DISTINCT p.*
FROM products AS p
JOIN sale_items AS sit
    ON sit.product_id = p.id
WHERE NOT EXISTS (
    SELECT pit.id FROM purchase_items AS pit WHERE pit.product_id = p.id
);