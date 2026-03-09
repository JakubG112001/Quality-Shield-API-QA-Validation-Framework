# Screenshots

This folder contains visual evidence of test execution results.

## test-results-positive.png
Screenshot of positive test suite - all 9 assertions passing with 0 failures.
Shows the happy path: authentication, CRUD operations working correctly.

## test-results-negative.png
Screenshot of negative test suite - 12 assertions testing error handling.
Shows security testing: invalid auth, missing fields, SQL injection attempts.
Demonstrates ability to find vulnerabilities through testing.

## How to Add Your Screenshots

1. Run positive tests: `newman run restful-booker-tests.postman_collection.json`
2. Take screenshot, save as `test-results-positive.png`
3. Run negative tests: `newman run restful-booker-negative-tests.postman_collection.json`
4. Take screenshot, save as `test-results-negative.png`