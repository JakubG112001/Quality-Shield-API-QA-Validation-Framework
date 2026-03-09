# Bug Reports - Manual QA Documentation

## Overview
This folder contains professional bug reports discovered through systematic testing of live applications. Each report follows industry-standard documentation practices.

## Bug Report Structure

Every bug report includes:
- **Summary**: One-line description
- **Severity**: Critical, High, Medium, or Low
- **Environment**: Browser, OS, device details
- **Steps to Reproduce**: Exact sequence to trigger the bug
- **Expected vs Actual Results**: What should happen vs what does happen
- **Visual Evidence**: Screenshots, console logs, network activity
- **Root Cause Analysis**: Investigation findings
- **Suggested Fix**: Proposed solution

## Current Bug Reports

### BUG-001: Email Validation Bypass
- **Severity**: High
- **Issue**: Form accepts invalid email formats
- **Impact**: Data quality issues, unable to contact users

### BUG-002: Session Timeout Not Working
- **Severity**: Critical (Security)
- **Issue**: User sessions don't expire after stated timeout
- **Impact**: Security vulnerability, compliance violation

### BUG-003: Broken Pagination on Mobile
- **Severity**: Medium
- **Issue**: Pagination buttons overlap and unclickable on mobile
- **Impact**: Users cannot navigate product listings on mobile devices

### BUG-004: Password Visibility Toggle Not Working
- **Severity**: Medium
- **Issue**: Eye icon button doesn't reveal password text
- **Impact**: Poor UX, users cannot verify password before submitting

### BUG-005: Search Returns No Results for Valid Queries
- **Severity**: High
- **Issue**: Case-sensitive search fails for lowercase queries
- **Impact**: Lost sales, users think products don't exist

### BUG-006: File Upload Fails Without Error Message
- **Severity**: High
- **Issue**: Large file uploads fail silently with no user feedback
- **Impact**: User frustration, repeated failed attempts

### BUG-007: Date Picker Allows Past Dates for Future Events
- **Severity**: High
- **Issue**: Event booking accepts dates that already passed
- **Impact**: Invalid bookings, refund requests, data integrity issues

### BUG-008: Shopping Cart Quantity Accepts Negative Numbers
- **Severity**: Critical
- **Issue**: Cart allows negative quantities resulting in negative totals
- **Impact**: Potential revenue loss, security vulnerability

## Testing Methodology

### Bug Bash Process
1. **Scope Definition**: Identify features to test
2. **Test Case Creation**: Document expected behavior
3. **Exploratory Testing**: Try edge cases and unusual inputs
4. **Documentation**: Record all findings professionally
5. **Severity Assessment**: Prioritize based on impact
6. **Root Cause Investigation**: Use DevTools to analyze

### Tools Used
- **Browser DevTools**: Console, Network tab, Elements inspector
- **Screenshot Tools**: For visual documentation
- **Network Monitoring**: To analyze API requests/responses
- **Console Logging**: To capture JavaScript errors

## What This Demonstrates

### QA Skills
- Systematic testing approach
- Professional documentation
- Root cause analysis
- Security awareness
- Attention to detail

### Technical Knowledge
- Understanding of web technologies
- API communication
- Authentication mechanisms
- Data validation principles
- Browser debugging tools

### Communication
- Clear, concise writing
- Structured documentation
- Actionable recommendations
- Severity assessment

## How to Use This Template

1. Copy `bug-report-template.md`
2. Fill in all sections thoroughly
3. Include actual evidence (screenshots, logs)
4. Provide clear reproduction steps
5. Suggest fixes when possible

## Severity Guidelines

### Critical
- System crashes
- Data loss
- Security vulnerabilities
- Complete feature failure

### High
- Major functionality broken
- Significant user impact
- Data integrity issues
- Workaround difficult

### Medium
- Feature not working as expected
- Moderate user impact
- Workaround available

### Low
- Minor issues
- Cosmetic problems
- Minimal user impact

## Real-World Value

These bug reports demonstrate:
- **Proactive Quality Mindset**: Finding issues before users do
- **Professional Communication**: Clear, actionable documentation
- **Technical Depth**: Understanding root causes, not just symptoms
- **Business Awareness**: Assessing impact and priority

---

**Note**: Bug reports in this folder are examples for portfolio purposes. Always respect responsible disclosure practices when reporting real security vulnerabilities.