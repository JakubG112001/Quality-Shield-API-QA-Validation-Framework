# API Automated Tests

## Overview
This folder contains automated API tests for the Restful-Booker API, demonstrating end-to-end testing of a booking system.

## Test Results

See `screenshots/` folder for visual proof of test execution.

**Positive Tests**: 6 requests, 9 assertions, 0 failures - validates happy path
**Negative Tests**: 6 requests, 12 assertions, 0 failures - validates error handling and security

### What the Tests Cover

**Positive Testing** (`restful-booker-tests.postman_collection.json`):
- API health check
- Authentication flow
- Create, read, update, delete operations
- Data integrity validation
- Response time performance

**Negative Testing** (`restful-booker-negative-tests.postman_collection.json`):
- Invalid authentication attempts
- Missing required fields (found: returns 500 instead of 400)
- Non-existent resources
- Unauthorized access attempts
- Invalid data types (found: weak type validation)
- SQL injection attempts (found: input not sanitized)

## Test Coverage

### 1. Health Check
- Verifies API availability
- Ensures system is responsive

### 2. Authentication Flow
- Tests token generation
- Validates credentials
- Stores auth token for subsequent requests

### 3. CRUD Operations
- **Create**: New booking with customer details
- **Read**: Retrieve booking by ID
- **Update**: Modify existing booking
- **Delete**: Remove booking from system

### 4. Validation Tests
- Response status codes
- Data integrity checks
- Response time performance
- Error handling

## How to Run

### Using Postman (GUI)
1. Install [Postman](https://www.postman.com/downloads/)
2. Import `restful-booker-tests.postman_collection.json`
3. Click "Run Collection"
4. View test results

### Using Newman (CLI - Automated)
```bash
# Install Newman
npm install -g newman

# Run tests
newman run restful-booker-tests.postman_collection.json

# Generate HTML report
newman run restful-booker-tests.postman_collection.json -r html
```

## Test Results Example
```
→ Health Check
  ✓ API is healthy

→ Create Auth Token
  ✓ Authentication successful

→ Create Booking
  ✓ Booking created successfully
  ✓ Booking contains correct data

→ Get Booking
  ✓ Booking retrieved successfully
  ✓ Response time is acceptable

→ Update Booking
  ✓ Booking updated successfully
  ✓ Updated data is correct

→ Delete Booking
  ✓ Booking deleted successfully
```

## What This Demonstrates
- API testing automation
- Authentication flow validation
- Test assertion writing
- CI/CD integration capability
- Professional testing practices