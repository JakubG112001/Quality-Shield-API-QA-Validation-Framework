# Quality Shield - API & QA Validation Framework

A comprehensive QA testing framework demonstrating real-world testing practices through automated API testing, bug discovery, and database validation.

## Project Overview

This project showcases quality assurance skills by testing existing systems rather than building new applications. It includes automated API tests, professional bug reports, and SQL validation scripts.

## Project Structure

```
quality-shield/
├── api-tests/              # Automated API test collections
│   ├── restful-booker-tests.postman_collection.json
│   ├── restful-booker-negative-tests.postman_collection.json
│   └── screenshots/        # Test execution results
├── bug-reports/            # Professional bug documentation (8 reports)
│   ├── BUG-001-email-validation-bypass.md
│   ├── BUG-002-session-timeout-not-working.md
│   └── ...
├── sql-validation/         # Database integrity testing
│   └── data-integrity-tests.sql
└── README.md
```

## Key Features

### 1. Automated API Testing
- **6 positive test cases** validating happy path scenarios
- **6 negative test cases** testing error handling and security
- Tests authentication flows, CRUD operations, and data integrity
- Response time validation and status code verification
- Can be integrated into CI/CD pipelines

### 2. Bug Discovery & Documentation
- **8 professionally documented bugs** found on live applications
- Includes reproduction steps, root cause analysis, and suggested fixes
- Uses browser DevTools for network analysis and console debugging
- Demonstrates systematic testing approach

### 3. SQL Validation Scripts
- **12 data integrity checks** for common database issues
- Detects invalid formats (emails, phone numbers)
- Identifies boundary violations (negative prices, future dates)
- Finds orphaned records and referential integrity issues

## Quick Start

### Prerequisites
- [Postman](https://www.postman.com/downloads/) (for GUI testing)
- [Node.js](https://nodejs.org/) (optional, for CLI testing)

### Running API Tests

**Option 1: Using Postman (Recommended for beginners)**
1. Download and install Postman
2. Import `api-tests/restful-booker-tests.postman_collection.json`
3. Click "Run Collection"
4. View test results with green checkmarks

**Option 2: Using Newman (Command Line)**
```bash
# Install Newman
npm install -g newman

# Run positive tests
cd api-tests
newman run restful-booker-tests.postman_collection.json

# Run negative tests
newman run restful-booker-negative-tests.postman_collection.json

# Generate HTML report
newman run restful-booker-tests.postman_collection.json -r html
```

### Reviewing Bug Reports
Navigate to `bug-reports/` and open any `.md` file to see professional bug documentation structure.

### Understanding SQL Scripts
Open `sql-validation/data-integrity-tests.sql` to see validation queries for common data quality issues.

## Technologies Used

- **Postman** - API testing and automation
- **Newman** - CLI test runner for CI/CD integration
- **SQL** - Database validation and integrity checking
- **REST APIs** - HTTP request/response testing
- **Browser DevTools** - Network analysis and debugging

## Test Coverage

### API Tests
- Health check validation
- Authentication token generation
- Create booking (POST)
- Retrieve booking (GET)
- Update booking (PUT)
- Delete booking (DELETE)
- Response time performance
- Error handling and edge cases

### SQL Validations
- Email format validation
- Negative price detection
- Future date validation
- Orphaned records
- Duplicate detection
- Phone number format
- Age boundary validation
- Inventory anomalies
- Payment validation
- Date range validation
- NULL value audit
- Referential integrity

## What This Demonstrates

- Ability to test and validate existing systems
- Professional bug documentation skills
- Understanding of API authentication and CRUD operations
- Database integrity and data quality awareness
- Root cause analysis and problem-solving
- Use of industry-standard testing tools
- CI/CD integration capability

## Future Enhancements

- [ ] Add performance testing with load scenarios
- [ ] Implement security testing (SQL injection, XSS)
- [ ] Create automated test reports
- [ ] Add API contract testing
- [ ] Integrate with GitHub Actions for CI/CD

## License

This project is open source and available for educational purposes.

## Author

**Jakub Grzesiak**

Feel free to reach out if you have questions about this project!

---

*This project uses public APIs and demonstrates QA testing practices without requiring deployment or infrastructure.*
