-- Project: Shopping Management
DROP DATABASE IF EXISTS Shopping_Management;

CREATE DATABASE Shopping_Management;

USE Shopping_Management;


-- PART 2: CREATE CUSTOMERS TABLE
-- =====================================================

CREATE TABLE customers (

    Customer_Id INT UNSIGNED NOT NULL AUTO_INCREMENT,

    Customer_Name VARCHAR(100) NOT NULL,

    Email VARCHAR(254) NULL,

    Phone_Number CHAR(10) NOT NULL,

    Age INT UNSIGNED NOT NULL,

    Gender ENUM('Male', 'Female', 'Other') NOT NULL,

    Country VARCHAR(50) NOT NULL DEFAULT 'India',

    City VARCHAR(50) NOT NULL,

    Pincode CHAR(6) NOT NULL DEFAULT '201301',

    Registration_Date DATE NOT NULL DEFAULT (CURRENT_DATE),

    Registration_Time TIME NOT NULL DEFAULT (CURRENT_TIME),

    Created_At TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    Address VARCHAR(250),

    Customer_Status
        ENUM('Active', 'Inactive', 'Blocked')
        NOT NULL DEFAULT 'Active',

    Customer_Notes TEXT,

    PRIMARY KEY (Customer_Id),

    CONSTRAINT uq_customers_email
        UNIQUE (Email),

    CONSTRAINT uq_customers_phone
        UNIQUE (Phone_Number),

    CONSTRAINT chk_customers_phone
        CHECK (Phone_Number REGEXP '^[0-9]{10}$'),

    CONSTRAINT chk_customers_age
        CHECK (Age > 0),

    CONSTRAINT chk_customers_pincode
        CHECK (Pincode REGEXP '^[0-9]{6}$'),

    CONSTRAINT chk_customers_notes
        CHECK (
            Customer_Notes IS NULL
            OR OCTET_LENGTH(Customer_Notes) < 1024
        )

) ENGINE = InnoDB;


-- PART 3: CREATE ORDERS TABLE
-- =====================================================

CREATE TABLE orders (

    Order_Id INT UNSIGNED NOT NULL AUTO_INCREMENT,

    Customer_Id INT UNSIGNED NOT NULL,

    Order_Date DATE NOT NULL DEFAULT (CURRENT_DATE),

    Order_Amount DECIMAL(12,2) NOT NULL,

    Order_Status
        ENUM(
            'Pending',
            'Processing',
            'Shipped',
            'Delivered',
            'Cancelled'
        )
        NOT NULL DEFAULT 'Pending',

    Payment_Method
        ENUM('Cash', 'Card', 'UPI', 'Net Banking')
        NOT NULL,

    Payment_Status
        ENUM('Pending', 'Paid', 'Failed')
        NOT NULL DEFAULT 'Pending',

    Shipping_Address VARCHAR(250) NOT NULL,

    Delivery_Pincode CHAR(6) NOT NULL,

    Quantity INT UNSIGNED NOT NULL,

    Discount_Amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,

    Delivery_Date DATE DEFAULT NULL,

    Created_At TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    Tracking_Number VARCHAR(30) DEFAULT NULL,

    Delivery_Status
        ENUM(
            'Not Dispatched',
            'In Transit',
            'Delivered',
            'Returned'
        )
        NOT NULL DEFAULT 'Not Dispatched',

    Order_Notes TEXT,

    PRIMARY KEY (Order_Id),

    CONSTRAINT uq_orders_tracking_number
        UNIQUE (Tracking_Number),

    CONSTRAINT chk_orders_amount
        CHECK (Order_Amount >= 0),

    CONSTRAINT chk_orders_quantity
        CHECK (Quantity > 0),

    CONSTRAINT chk_orders_discount
        CHECK (Discount_Amount >= 0),

    CONSTRAINT chk_orders_delivery_pincode
        CHECK (Delivery_Pincode REGEXP '^[0-9]{6}$'),

    CONSTRAINT chk_orders_notes
        CHECK (
            Order_Notes IS NULL
            OR OCTET_LENGTH(Order_Notes) < 1024
        ),

    CONSTRAINT fk_orders_customers
        FOREIGN KEY (Customer_Id)
        REFERENCES customers (Customer_Id)
        ON DELETE CASCADE
        ON UPDATE CASCADE

) ENGINE = InnoDB;


-- PART 4: INSERT SAMPLE CUSTOMER
-- =====================================================

INSERT INTO customers
    (Customer_Name, Email, Phone_Number, Age, Gender, City)
VALUES
    (
        'Rahul Sharma',
        'rahul.test@example.com',
        '9876543210',
        25,
        'Male',
        'Noida'
    );


-- Save the newly created customer's ID
SET @sample_customer_id = LAST_INSERT_ID();


-- PART 5: INSERT SAMPLE ORDER
-- =====================================================

INSERT INTO orders
    (
        Customer_Id,
        Order_Amount,
        Payment_Method,
        Shipping_Address,
        Delivery_Pincode,
        Quantity
    )
VALUES
    (
        @sample_customer_id,
        1500.00,
        'UPI',
        'Sector 15, Noida',
        '201301',
        2
    );


-- PART 6: DISPLAY DATABASE TABLES
-- =====================================================

SHOW TABLES;


-- PART 7: DISPLAY CUSTOMERS TABLE STRUCTURE
-- =====================================================

DESCRIBE customers;


-- PART 8: DISPLAY ORDERS TABLE STRUCTURE
-- =====================================================

DESCRIBE orders;


-- PART 9: DISPLAY CUSTOMER RECORDS
-- =====================================================

SELECT * FROM customers;


-- PART 10: DISPLAY ORDER RECORDS
-- =====================================================

SELECT * FROM orders;


-- PART 11: TEST CUSTOMER-ORDER RELATIONSHIP
-- =====================================================

SELECT
    customers.Customer_Id,
    customers.Customer_Name,
    orders.Order_Id,
    orders.Order_Amount,
    orders.Order_Status
FROM customers
INNER JOIN orders
    ON customers.Customer_Id = orders.Customer_Id;

SHOW CREATE TABLE orders;



     