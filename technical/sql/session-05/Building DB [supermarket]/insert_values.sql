-- ============================================================
-- SUPERMARKET DATABASE
-- SAMPLE / SEED DATA
-- PostgreSQL
-- ============================================================
--
-- This script inserts realistic sample data into the
-- supermarket database.
--
-- Required tables:
--   categories
--   products
--   suppliers
--   customers
--   purchase_invoices
--   purchase_items
--   sales_invoices
--   sale_items
--
-- IMPORTANT:
-- Run the database schema script FIRST.
-- Then run this script.
--
-- ============================================================


-- ============================================================
-- 1. INSERT CATEGORIES
-- ============================================================
-- Product categories used by the supermarket.
-- ============================================================

INSERT INTO categories (name)
VALUES
    ('Drinks'),
    ('Dairy'),
    ('Grocery'),
    ('Snacks'),
    ('Cleaning'),
    ('Personal Care'),
    ('Frozen Food'),
    ('Canned Food');


-- ============================================================
-- 2. INSERT SUPPLIERS
-- ============================================================
-- Suppliers who provide products to the supermarket.
-- ============================================================

INSERT INTO suppliers
    (name, phone, email, address, balance)
VALUES
    (
        'Al Nile Food Distribution',
        '01010000001',
        'sales@alnilefood.com',
        'Cairo',
        0
    ),
    (
        'Egyptian Beverages Company',
        '01010000002',
        'info@egybeverages.com',
        'Giza',
        0
    ),
    (
        'Delta Grocery Supplier',
        '01010000003',
        'delta@grocery.com',
        'Zagazig',
        0
    ),
    (
        'Fresh Dairy Company',
        '01010000004',
        'sales@freshdairy.com',
        'Mansoura',
        0
    ),
    (
        'Clean Home Distribution',
        '01010000005',
        'info@cleanhome.com',
        'Cairo',
        0
    );


-- ============================================================
-- 3. INSERT CUSTOMERS
-- ============================================================
-- Registered customers.
--
-- Note:
-- Cash customers do not necessarily need a record here.
-- Their customer_id can remain NULL in sales_invoices.
-- ============================================================

INSERT INTO customers
    (name, phone, email, address, balance)
VALUES
    (
        'Ahmed Mohamed',
        '01120000001',
        'ahmed@example.com',
        'Zagazig',
        0
    ),
    (
        'Mohamed Ali',
        '01120000002',
        'mohamed@example.com',
        'Zagazig',
        0
    ),
    (
        'Mahmoud Hassan',
        '01120000003',
        'mahmoud@example.com',
        'Cairo',
        0
    ),
    (
        'Omar Ibrahim',
        '01120000004',
        'omar@example.com',
        'Belbeis',
        0
    ),
    (
        'Mostafa Ahmed',
        '01120000005',
        'mostafa@example.com',
        'Abu Hammad',
        0
    ),
    (
        'Sara Mohamed',
        '01120000006',
        'sara@example.com',
        'Zagazig',
        0
    );


-- ============================================================
-- 4. INSERT PRODUCTS
-- ============================================================
-- Products sold by the supermarket.
--
-- category_id values depend on the category insertion order:
--
-- 1 = Drinks
-- 2 = Dairy
-- 3 = Grocery
-- 4 = Snacks
-- 5 = Cleaning
-- 6 = Personal Care
-- 7 = Frozen Food
-- 8 = Canned Food
-- ============================================================

INSERT INTO products
    (
        name,
        barcode,
        category_id,
        purchase_price,
        sale_price,
        min_stock
    )
VALUES

    -- =========================
    -- Drinks
    -- =========================

    (
        'Pepsi 330ml',
        '622100000001',
        1,
        10.00,
        15.00,
        20
    ),

    (
        'Coca Cola 330ml',
        '622100000002',
        1,
        10.00,
        15.00,
        20
    ),

    (
        'Mirinda Orange 330ml',
        '622100000003',
        1,
        9.00,
        14.00,
        15
    ),

    (
        'Mineral Water 1.5L',
        '622100000004',
        1,
        5.00,
        8.00,
        30
    ),

    (
        'Juice Mango 1L',
        '622100000005',
        1,
        22.00,
        30.00,
        10
    ),


    -- =========================
    -- Dairy
    -- =========================

    (
        'Full Cream Milk 1L',
        '622100000006',
        2,
        25.00,
        32.00,
        15
    ),

    (
        'Yogurt Plain 105g',
        '622100000007',
        2,
        6.00,
        9.00,
        30
    ),

    (
        'White Cheese 500g',
        '622100000008',
        2,
        35.00,
        45.00,
        10
    ),

    (
        'Chocolate Milk 200ml',
        '622100000009',
        2,
        10.00,
        14.00,
        15
    ),


    -- =========================
    -- Grocery
    -- =========================

    (
        'Rice 1kg',
        '622100000010',
        3,
        30.00,
        38.00,
        20
    ),

    (
        'Sugar 1kg',
        '622100000011',
        3,
        25.00,
        30.00,
        20
    ),

    (
        'Flour 1kg',
        '622100000012',
        3,
        22.00,
        28.00,
        15
    ),

    (
        'Cooking Oil 1L',
        '622100000013',
        3,
        55.00,
        65.00,
        15
    ),

    (
        'Pasta 400g',
        '622100000014',
        3,
        10.00,
        14.00,
        30
    ),


    -- =========================
    -- Snacks
    -- =========================

    (
        'Potato Chips 50g',
        '622100000015',
        4,
        7.00,
        10.00,
        30
    ),

    (
        'Chocolate Bar 50g',
        '622100000016',
        4,
        12.00,
        18.00,
        20
    ),

    (
        'Biscuits 100g',
        '622100000017',
        4,
        8.00,
        12.00,
        25
    ),

    (
        'Corn Snacks 50g',
        '622100000018',
        4,
        6.00,
        9.00,
        20
    ),


    -- =========================
    -- Cleaning
    -- =========================

    (
        'Dishwashing Liquid 500ml',
        '622100000019',
        5,
        20.00,
        28.00,
        10
    ),

    (
        'Laundry Detergent 1kg',
        '622100000020',
        5,
        45.00,
        55.00,
        10
    ),

    (
        'Floor Cleaner 1L',
        '622100000021',
        5,
        30.00,
        40.00,
        10
    ),


    -- =========================
    -- Personal Care
    -- =========================

    (
        'Shampoo 400ml',
        '622100000022',
        6,
        50.00,
        65.00,
        10
    ),

    (
        'Bath Soap 125g',
        '622100000023',
        6,
        10.00,
        15.00,
        20
    ),

    (
        'Toothpaste 100ml',
        '622100000024',
        6,
        25.00,
        35.00,
        15
    ),


    -- =========================
    -- Frozen Food
    -- =========================

    (
        'Frozen Peas 400g',
        '622100000025',
        7,
        25.00,
        35.00,
        10
    ),

    (
        'Frozen Mixed Vegetables 400g',
        '622100000026',
        7,
        28.00,
        38.00,
        10
    ),

    (
        'Frozen French Fries 1kg',
        '622100000027',
        7,
        45.00,
        60.00,
        10
    ),


    -- =========================
    -- Canned Food
    -- =========================

    (
        'Tuna Can 140g',
        '622100000028',
        8,
        35.00,
        45.00,
        10
    ),

    (
        'Tomato Paste 400g',
        '622100000029',
        8,
        15.00,
        22.00,
        15
    ),

    (
        'Canned Beans 400g',
        '622100000030',
        8,
        18.00,
        25.00,
        15
    );


-- ============================================================
-- 5. PURCHASE INVOICES
-- ============================================================
-- Purchase invoice headers.
--
-- We create several invoices from different suppliers
-- on different dates.
-- ============================================================


INSERT INTO purchase_invoices
    (
        invoice_number,
        supplier_id,
        invoice_date,
        total_amount,
        discount,
        paid_amount,
        remaining_amount,
        notes
    )
VALUES

    (
        'PUR-1001',
        1,
        '2026-09-01 09:30:00',
        2250.00,
        50.00,
        1500.00,
        700.00,
        'First grocery stock purchase'
    ),

    (
        'PUR-1002',
        2,
        '2026-09-03 10:15:00',
        1800.00,
        0.00,
        1800.00,
        0.00,
        'Drinks purchase'
    ),

    (
        'PUR-1003',
        3,
        '2026-09-05 11:00:00',
        1500.00,
        100.00,
        1000.00,
        400.00,
        'Grocery products'
    ),

    (
        'PUR-1004',
        4,
        '2026-09-07 08:45:00',
        1200.00,
        0.00,
        1200.00,
        0.00,
        'Dairy products'
    ),

    (
        'PUR-1005',
        5,
        '2026-09-09 12:30:00',
        2100.00,
        100.00,
        2000.00,
        0.00,
        'Cleaning products'
    );


-- ============================================================
-- 6. PURCHASE ITEMS
-- ============================================================
-- Products contained inside each purchase invoice.
--
-- NOTE:
-- The "total" column represents the total for that item
-- after item-level discount.
-- ============================================================


-- ------------------------------------------------------------
-- Invoice PUR-1001
-- Supplier: Al Nile Food Distribution
-- ------------------------------------------------------------

INSERT INTO purchase_items
    (
        purchase_invoice_id,
        product_id,
        quantity,
        purchase_price,
        discount,
        total
    )
VALUES
    (1, 10, 30, 30.00, 0.00, 900.00),
    (1, 11, 30, 25.00, 0.00, 750.00),
    (1, 14, 60, 10.00, 0.00, 600.00);


-- ------------------------------------------------------------
-- Invoice PUR-1002
-- Supplier: Egyptian Beverages Company
-- ------------------------------------------------------------

INSERT INTO purchase_items
    (
        purchase_invoice_id,
        product_id,
        quantity,
        purchase_price,
        discount,
        total
    )
VALUES
    (2, 1, 50, 10.00, 0.00, 500.00),
    (2, 2, 50, 10.00, 0.00, 500.00),
    (2, 3, 50, 9.00, 0.00, 450.00),
    (2, 4, 70, 5.00, 0.00, 350.00);


-- ------------------------------------------------------------
-- Invoice PUR-1003
-- Supplier: Delta Grocery Supplier
-- ------------------------------------------------------------

INSERT INTO purchase_items
    (
        purchase_invoice_id,
        product_id,
        quantity,
        purchase_price,
        discount,
        total
    )
VALUES
    (3, 12, 30, 22.00, 0.00, 660.00),
    (3, 13, 20, 55.00, 50.00, 1050.00),
    (3, 15, 30, 7.00, 0.00, 210.00);


-- ------------------------------------------------------------
-- Invoice PUR-1004
-- Supplier: Fresh Dairy Company
-- ------------------------------------------------------------

INSERT INTO purchase_items
    (
        purchase_invoice_id,
        product_id,
        quantity,
        purchase_price,
        discount,
        total
    )
VALUES
    (4, 6, 30, 25.00, 0.00, 750.00),
    (4, 7, 50, 6.00, 0.00, 300.00),
    (4, 9, 15, 10.00, 0.00, 150.00);


-- ------------------------------------------------------------
-- Invoice PUR-1005
-- Supplier: Clean Home Distribution
-- ------------------------------------------------------------

INSERT INTO purchase_items
    (
        purchase_invoice_id,
        product_id,
        quantity,
        purchase_price,
        discount,
        total
    )
VALUES
    (5, 19, 30, 20.00, 0.00, 600.00),
    (5, 20, 25, 45.00, 50.00, 1075.00),
    (5, 21, 15, 30.00, 0.00, 450.00);


-- ============================================================
-- 7. SALES INVOICES
-- ============================================================
-- Sales invoice headers.
--
-- Some invoices have registered customers.
-- Some invoices are cash sales with customer_id = NULL.
-- ============================================================


INSERT INTO sales_invoices
    (
        invoice_number,
        customer_id,
        invoice_date,
        total_amount,
        discount,
        paid_amount,
        remaining_amount,
        notes
    )
VALUES

    (
        'SAL-1001',
        1,
        '2026-09-10 10:15:00',
        130.00,
        0.00,
        130.00,
        0.00,
        'Regular customer sale'
    ),

    (
        'SAL-1002',
        NULL,
        '2026-09-10 11:30:00',
        95.00,
        5.00,
        90.00,
        0.00,
        'Cash sale'
    ),

    (
        'SAL-1003',
        2,
        '2026-09-11 12:10:00',
        220.00,
        20.00,
        150.00,
        50.00,
        'Credit sale'
    ),

    (
        'SAL-1004',
        NULL,
        '2026-09-11 15:20:00',
        180.00,
        0.00,
        180.00,
        0.00,
        'Cash sale'
    ),

    (
        'SAL-1005',
        3,
        '2026-09-12 09:45:00',
        310.00,
        10.00,
        300.00,
        0.00,
        'Regular customer sale'
    ),

    (
        'SAL-1006',
        4,
        '2026-09-12 13:30:00',
        275.00,
        0.00,
        275.00,
        0.00,
        'Regular customer sale'
    ),

    (
        'SAL-1007',
        NULL,
        '2026-09-13 17:10:00',
        145.00,
        0.00,
        145.00,
        0.00,
        'Cash sale'
    ),

    (
        'SAL-1008',
        5,
        '2026-09-14 10:00:00',
        390.00,
        15.00,
        375.00,
        0.00,
        'Regular customer sale'
    ),

    (
        'SAL-1009',
        6,
        '2026-09-14 11:45:00',
        210.00,
        10.00,
        200.00,
        0.00,
        'Regular customer sale'
    ),

    (
        'SAL-1010',
        NULL,
        '2026-09-14 12:30:00',
        165.00,
        0.00,
        165.00,
        0.00,
        'Cash sale'
    );


-- ============================================================
-- 8. SALE ITEMS
-- ============================================================
-- Products contained inside each sales invoice.
-- ============================================================


-- ------------------------------------------------------------
-- Invoice SAL-1001
-- Customer: Ahmed Mohamed
-- ------------------------------------------------------------

INSERT INTO sale_items
    (
        sales_invoice_id,
        product_id,
        quantity,
        sale_price,
        discount,
        total
    )
VALUES
    (1, 1, 3, 15.00, 0.00, 45.00),
    (1, 15, 5, 10.00, 0.00, 50.00),
    (1, 17, 2, 12.00, 0.00, 24.00),
    (1, 23, 1, 15.00, 0.00, 15.00);


-- ------------------------------------------------------------
-- Invoice SAL-1002
-- Cash customer
-- ------------------------------------------------------------

INSERT INTO sale_items
    (
        sales_invoice_id,
        product_id,
        quantity,
        sale_price,
        discount,
        total
    )
VALUES
    (2, 4, 5, 8.00, 0.00, 40.00),
    (2, 15, 3, 10.00, 5.00, 25.00),
    (2, 14, 2, 14.00, 0.00, 28.00);


-- ------------------------------------------------------------
-- Invoice SAL-1003
-- Customer: Mohamed Ali
-- ------------------------------------------------------------

INSERT INTO sale_items
    (
        sales_invoice_id,
        product_id,
        quantity,
        sale_price,
        discount,
        total
    )
VALUES
    (3, 6, 3, 32.00, 0.00, 96.00),
    (3, 10, 2, 38.00, 0.00, 76.00),
    (3, 13, 1, 65.00, 0.00, 65.00);


-- ------------------------------------------------------------
-- Invoice SAL-1004
-- Cash customer
-- ------------------------------------------------------------

INSERT INTO sale_items
    (
        sales_invoice_id,
        product_id,
        quantity,
        sale_price,
        discount,
        total
    )
VALUES
    (4, 2, 4, 15.00, 0.00, 60.00),
    (4, 4, 5, 8.00, 0.00, 40.00),
    (4, 16, 3, 18.00, 0.00, 54.00),
    (4, 18, 3, 9.00, 0.00, 27.00);


-- ------------------------------------------------------------
-- Invoice SAL-1005
-- Customer: Mahmoud Hassan
-- ------------------------------------------------------------

INSERT INTO sale_items
    (
        sales_invoice_id,
        product_id,
        quantity,
        sale_price,
        discount,
        total
    )
VALUES
    (5, 20, 2, 55.00, 0.00, 110.00),
    (5, 21, 2, 40.00, 0.00, 80.00),
    (5, 22, 1, 65.00, 0.00, 65.00),
    (5, 24, 1, 35.00, 0.00, 35.00);


-- ------------------------------------------------------------
-- Invoice SAL-1006
-- Customer: Omar Ibrahim
-- ------------------------------------------------------------

INSERT INTO sale_items
    (
        sales_invoice_id,
        product_id,
        quantity,
        sale_price,
        discount,
        total
    )
VALUES
    (6, 25, 2, 35.00, 0.00, 70.00),
    (6, 26, 2, 38.00, 0.00, 76.00),
    (6, 27, 1, 60.00, 0.00, 60.00),
    (6, 28, 1, 45.00, 0.00, 45.00);


-- ------------------------------------------------------------
-- Invoice SAL-1007
-- Cash customer
-- ------------------------------------------------------------

INSERT INTO sale_items
    (
        sales_invoice_id,
        product_id,
        quantity,
        sale_price,
        discount,
        total
    )
VALUES
    (7, 3, 3, 14.00, 0.00, 42.00),
    (7, 4, 5, 8.00, 0.00, 40.00),
    (7, 15, 4, 10.00, 0.00, 40.00),
    (7, 17, 2, 12.00, 0.00, 24.00);


-- ------------------------------------------------------------
-- Invoice SAL-1008
-- Customer: Mostafa Ahmed
-- ------------------------------------------------------------

INSERT INTO sale_items
    (
        sales_invoice_id,
        product_id,
        quantity,
        sale_price,
        discount,
        total
    )
VALUES
    (8, 10, 3, 38.00, 0.00, 114.00),
    (8, 11, 3, 30.00, 0.00, 90.00),
    (8, 13, 1, 65.00, 0.00, 65.00),
    (8, 19, 2, 28.00, 0.00, 56.00);


-- ------------------------------------------------------------
-- Invoice SAL-1009
-- Customer: Sara Mohamed
-- ------------------------------------------------------------

INSERT INTO sale_items
    (
        sales_invoice_id,
        product_id,
        quantity,
        sale_price,
        discount,
        total
    )
VALUES
    (9, 7, 5, 9.00, 0.00, 45.00),
    (9, 8, 2, 45.00, 0.00, 90.00),
    (9, 16, 2, 18.00, 0.00, 36.00),
    (9, 23, 2, 15.00, 0.00, 30.00);


-- ------------------------------------------------------------
-- Invoice SAL-1010
-- Cash customer
-- ------------------------------------------------------------

INSERT INTO sale_items
    (
        sales_invoice_id,
        product_id,
        quantity,
        sale_price,
        discount,
        total
    )
VALUES
    (10, 1, 2, 15.00, 0.00, 30.00),
    (10, 6, 2, 32.00, 0.00, 64.00),
    (10, 14, 3, 14.00, 0.00, 42.00),
    (10, 29, 1, 22.00, 0.00, 22.00);


-- ============================================================
-- END OF SAMPLE DATA
-- ============================================================

