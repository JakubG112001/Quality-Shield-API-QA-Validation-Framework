# Bug Report - Session Timeout Not Working

## Bug ID: BUG-002

### Summary
User session remains active after stated 30-minute timeout period

### Severity
- [x] Critical
- [ ] High
- [ ] Medium
- [ ] Low

### Environment
- **Browser**: Firefox 121.0
- **OS**: Windows 11
- **Device**: Desktop
- **Screen Resolution**: 1920x1080

### Steps to Reproduce
1. Log in to application at `https://example-site.com/login`
2. Navigate to dashboard
3. Leave browser tab open without any activity
4. Wait 35 minutes (5 minutes past stated 30-minute timeout)
5. Click on any feature in the dashboard
6. Observe that user can still interact with the system

### Expected Result
- After 30 minutes of inactivity, session should expire
- User should be automatically logged out
- Attempting to interact should redirect to login page
- Warning message: "Your session has expired. Please log in again."

### Actual Result
- Session remains active after 30+ minutes
- User can continue to access protected resources
- No logout occurs
- No timeout warning displayed

### Visual Evidence
**Test Log**:
- Login time: 14:00:00
- Last activity: 14:00:30
- Test interaction: 14:35:45 (35 minutes later)
- Result: Dashboard still accessible, data loads successfully

### Console Errors
No errors - session token still valid

### Network Activity
**Request at 14:35:45** (after timeout should have occurred):
- **Request URL**: `https://example-site.com/api/dashboard/data`
- **Method**: GET
- **Status Code**: 200 OK
- **Request Headers**:
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Cookie: session_id=abc123xyz789
```
- **Response**: Valid data returned (should be 401 Unauthorized)

### Reproducibility
- [x] Always (100%)
- [ ] Often (75%)
- [ ] Sometimes (50%)
- [ ] Rarely (25%)

### Root Cause Analysis
Session timeout mechanism is not implemented or not functioning correctly. Possible causes:

1. **JWT Token Issue**: Token expiration (`exp` claim) may be set too long or not checked
2. **Session Management**: Server-side session timeout not configured
3. **Client-Side Check**: No JavaScript timer to detect inactivity
4. **Cookie Settings**: Session cookie may have incorrect `Max-Age` or `Expires` attribute

**JWT Token Inspection** (decoded):
```json
{
  "userId": 12345,
  "email": "user@example.com",
  "iat": 1705327200,
  "exp": 1705413600
}
```
Token expiration is set to 24 hours instead of 30 minutes!

### Suggested Fix
1. **Backend**: Set JWT expiration to 30 minutes:
   ```javascript
   const token = jwt.sign(payload, secret, { expiresIn: '30m' });
   ```
2. **Backend**: Implement session timeout check on each request
3. **Frontend**: Add inactivity detection:
   ```javascript
   let inactivityTimer;
   function resetTimer() {
     clearTimeout(inactivityTimer);
     inactivityTimer = setTimeout(logout, 30 * 60 * 1000); // 30 min
   }
   document.addEventListener('mousemove', resetTimer);
   document.addEventListener('keypress', resetTimer);
   ```
4. **Frontend**: Display warning 5 minutes before timeout

### Impact
- **Security Risk**: Unattended sessions remain active
- **Compliance Issue**: Violates security policy requiring 30-minute timeout
- **Data Exposure**: Sensitive data accessible on unattended devices
- **Audit Failure**: Does not meet industry standards (OWASP, PCI-DSS)

### Additional Notes
This is a critical security vulnerability. If a user walks away from their computer in a public space, their account remains accessible. This violates the stated security policy and could lead to unauthorized access to sensitive data.

**Related Issues**: Check if "Remember Me" functionality also has timeout issues.

---

**Reported By**: QA Engineer  
**Date**: 2024-01-15  
**Last Updated**: 2024-01-15  
**Priority**: URGENT - Security Issue