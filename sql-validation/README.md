# SQL Validation Scripts

## Overview
This folder contains SQL scripts designed to audit database integrity and identify data quality issues through boundary value testing and format validation.

## Purpose
These scripts demonstrate the ability to:
- Validate data integrity at the database level
- Identify edge cases and boundary violations
- Detect orphaned records and referential integrity issues
- Audit data quality systematically

## Test Categories

### 1. Format Validation
- **Email Format**: Detects invalid email patterns
- **Phone Numbers**: Validates phone number formats
- **Date Formats**: Ensures dates are in valid ranges

### 2. Boundary Value Testing
- **Negative Values**: Finds prices, quantities, or amounts that shouldn't be negative
- **Age Ranges**: Identifies unrealistic ages (< 13 or > 120)
- **Date Ranges**: Detects illogical date combinations (checkout before checkin)

### 3. Referential Integrity
- **Orphaned Records**: Finds records referencing non-existent parent records
- **Missing References**: Identifies broken foreign key relationships

### 4. Data Quality
- **Duplicates**: Detects duplicate entries where uniqueness is required
- **NULL Values**: Finds required fields with missing data
- **Anomalies**: Identifies statistical outliers and suspicious patterns

## How to Use

### Running Individual Tests
```sql
-- Connect to your database
mysql -u username -p database_name

-- Run a specific validation
source data-integrity-tests.sql

-- Or run individual queries
SELECT * FROM users WHERE email NOT LIKE '%_@__%.__%';
```

### Generating Reports
```sql
-- Run the summary report at the end of the file
-- This gives you a count of all issues by severity
```

### Expected Output Example
```
+---------------------------+----------+-------------+
| issue_type                | severity | issue_count |
+---------------------------+----------+-------------+
| Negative price            | CRITICAL |           3 |
| Product reference missing | CRITICAL |           7 |
| Invalid email             | HIGH     |          15 |
| Duplicate email           | HIGH     |           8 |
| Age out of range          | MEDIUM   |           4 |
+---------------------------+----------+-------------+
```

## Real-World Application

### When to Run These Tests
- **Before Production Deploy**: Ensure data quality before going live
- **After Data Migration**: Validate that imported data is clean
- **Regular Audits**: Schedule weekly/monthly data quality checks
- **After Bulk Updates**: Verify that batch operations didn't corrupt data

### Integration with CI/CD
These scripts can be automated in your deployment pipeline:
```bash
# Example: Run validation and fail build if issues found
mysql -u user -p db < data-integrity-tests.sql > results.txt
if grep -q "CRITICAL" results.txt; then
    echo "Critical data issues found!"
    exit 1
fi
```

## What This Demonstrates

### Technical Skills
- SQL query writing and optimization
- Understanding of data integrity principles
- Database design knowledge
- Analytical problem-solving

### QA Mindset
- Proactive issue detection
- Systematic testing approach
- Focus on edge cases and boundaries
- Root cause identification

### Business Value
- Prevents data corruption
- Ensures regulatory compliance
- Maintains data quality standards
- Reduces production incidents

## Customization

These scripts are templates. Adapt them to your specific database schema:

```sql
-- Example: Customize for your table names
SELECT user_id, email 
FROM your_users_table  -- Change this
WHERE email NOT LIKE '%_@__%.__%';
```

## Common Issues Found

1. **Invalid Emails**: Users registered with malformed email addresses
2. **Negative Prices**: Products with prices set to negative values
3. **Orphaned Orders**: Orders referencing deleted customers
4. **Future Dates**: Birth dates or event dates set in the future
5. **Duplicate Accounts**: Multiple accounts with same email

---

**Note**: These scripts are designed for MySQL/PostgreSQL. Syntax may need adjustment for other databases (SQL Server, Oracle, etc.).