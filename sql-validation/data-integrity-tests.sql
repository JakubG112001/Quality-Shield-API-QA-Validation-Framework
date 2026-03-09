-- SQL Validation Scripts for Data Integrity Testing
-- These scripts identify data quality issues and boundary value violations

-- ============================================
-- 1. EMAIL FORMAT VALIDATION
-- ============================================
-- Find users with invalid email formats
SELECT 
    user_id,
    email,
    'Invalid email format' AS issue_type,
    'HIGH' AS severity
FROM users
WHERE email NOT LIKE '%_@__%.__%'
   OR email LIKE '%@%@%'
   OR email LIKE '% %'
   OR email IS NULL;

-- ============================================
-- 2. NEGATIVE PRICE DETECTION
-- ============================================
-- Find products with negative or zero prices
SELECT 
    product_id,
    product_name,
    price,
    'Negative or zero price' AS issue_type,
    'CRITICAL' AS severity
FROM products
WHERE price <= 0;

-- ============================================
-- 3. FUTURE DATE VALIDATION
-- ============================================
-- Find records with birth dates in the future
SELECT 
    user_id,
    username,
    birth_date,
    'Birth date in future' AS issue_type,
    'HIGH' AS severity
FROM users
WHERE birth_date > CURRENT_DATE;

-- ============================================
-- 4. ORPHANED RECORDS
-- ============================================
-- Find orders without corresponding customers
SELECT 
    o.order_id,
    o.customer_id,
    o.order_date,
    'Orphaned order - customer not found' AS issue_type,
    'MEDIUM' AS severity
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- ============================================
-- 5. DUPLICATE DETECTION
-- ============================================
-- Find duplicate email addresses
SELECT 
    email,
    COUNT(*) AS duplicate_count,
    'Duplicate email addresses' AS issue_type,
    'HIGH' AS severity
FROM users
GROUP BY email
HAVING COUNT(*) > 1;

-- ============================================
-- 6. PHONE NUMBER FORMAT VALIDATION
-- ============================================
-- Find invalid phone numbers (assuming format: digits only, 10-15 chars)
SELECT 
    user_id,
    phone_number,
    'Invalid phone format' AS issue_type,
    'MEDIUM' AS severity
FROM users
WHERE phone_number IS NOT NULL
  AND (
    LENGTH(REGEXP_REPLACE(phone_number, '[^0-9]', '')) < 10
    OR LENGTH(REGEXP_REPLACE(phone_number, '[^0-9]', '')) > 15
  );

-- ============================================
-- 7. BOUNDARY VALUE - AGE VALIDATION
-- ============================================
-- Find users with unrealistic ages (< 13 or > 120)
SELECT 
    user_id,
    username,
    birth_date,
    TIMESTAMPDIFF(YEAR, birth_date, CURRENT_DATE) AS age,
    'Age out of valid range' AS issue_type,
    'MEDIUM' AS severity
FROM users
WHERE TIMESTAMPDIFF(YEAR, birth_date, CURRENT_DATE) < 13
   OR TIMESTAMPDIFF(YEAR, birth_date, CURRENT_DATE) > 120;

-- ============================================
-- 8. INVENTORY ANOMALY DETECTION
-- ============================================
-- Find products with negative inventory
SELECT 
    product_id,
    product_name,
    stock_quantity,
    'Negative inventory' AS issue_type,
    'HIGH' AS severity
FROM products
WHERE stock_quantity < 0;

-- ============================================
-- 9. PAYMENT AMOUNT VALIDATION
-- ============================================
-- Find payments that exceed order total
SELECT 
    p.payment_id,
    p.order_id,
    p.amount AS payment_amount,
    o.total_amount AS order_total,
    (p.amount - o.total_amount) AS overpayment,
    'Payment exceeds order total' AS issue_type,
    'HIGH' AS severity
FROM payments p
JOIN orders o ON p.order_id = o.order_id
WHERE p.amount > o.total_amount;

-- ============================================
-- 10. DATE RANGE VALIDATION
-- ============================================
-- Find bookings where checkout is before checkin
SELECT 
    booking_id,
    customer_id,
    checkin_date,
    checkout_date,
    'Checkout before checkin' AS issue_type,
    'CRITICAL' AS severity
FROM bookings
WHERE checkout_date <= checkin_date;

-- ============================================
-- 11. NULL VALUE AUDIT
-- ============================================
-- Find required fields with NULL values
SELECT 
    'users' AS table_name,
    user_id AS record_id,
    'email' AS field_name,
    'Required field is NULL' AS issue_type,
    'HIGH' AS severity
FROM users
WHERE email IS NULL

UNION ALL

SELECT 
    'products' AS table_name,
    product_id AS record_id,
    'product_name' AS field_name,
    'Required field is NULL' AS issue_type,
    'HIGH' AS severity
FROM products
WHERE product_name IS NULL;

-- ============================================
-- 12. REFERENTIAL INTEGRITY CHECK
-- ============================================
-- Find products in orders that don't exist in products table
SELECT 
    oi.order_item_id,
    oi.order_id,
    oi.product_id,
    'Product reference not found' AS issue_type,
    'CRITICAL' AS severity
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

-- ============================================
-- SUMMARY REPORT
-- ============================================
-- Generate a summary of all data quality issues
SELECT 
    issue_type,
    severity,
    COUNT(*) AS issue_count
FROM (
    -- Combine all validation queries here
    SELECT 'Invalid email' AS issue_type, 'HIGH' AS severity FROM users WHERE email NOT LIKE '%_@__%.__%'
    UNION ALL
    SELECT 'Negative price' AS issue_type, 'CRITICAL' AS severity FROM products WHERE price <= 0
    UNION ALL
    SELECT 'Future birth date' AS issue_type, 'HIGH' AS severity FROM users WHERE birth_date > CURRENT_DATE
) AS all_issues
GROUP BY issue_type, severity
ORDER BY 
    CASE severity
        WHEN 'CRITICAL' THEN 1
        WHEN 'HIGH' THEN 2
        WHEN 'MEDIUM' THEN 3
        WHEN 'LOW' THEN 4
    END,
    issue_count DESC;