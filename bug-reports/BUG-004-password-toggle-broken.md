# Bug Report - Password Visibility Toggle Not Working

## Bug ID: BUG-004

### Summary
Password visibility toggle button does not reveal password text

### Severity
- [ ] Critical
- [ ] High
- [x] Medium
- [ ] Low

### Environment
- **Browser**: Firefox 121.0
- **OS**: Windows 11
- **Device**: Desktop
- **Screen Resolution**: 1920x1080

### Steps to Reproduce
1. Navigate to login page at `https://example-site.com/login`
2. Enter any text in the password field
3. Click the eye icon button to reveal password
4. Observe the password field

### Expected Result
- Password text should become visible when eye icon is clicked
- Icon should change from "eye" to "eye-slash" 
- Input type should change from "password" to "text"
- Clicking again should hide the password

### Actual Result
- Nothing happens when clicking the eye icon
- Password remains hidden as dots
- Icon does not change
- No visual feedback

### Visual Evidence
**Console Errors**:
```javascript
Uncaught TypeError: Cannot read properties of null (reading 'addEventListener')
    at password-toggle.js:3:15
```

### Network Activity
Not applicable - client-side JavaScript issue

### Reproducibility
- [x] Always (100%)
- [ ] Often (75%)
- [ ] Sometimes (50%)
- [ ] Rarely (25%)

### Root Cause Analysis
The JavaScript is trying to attach an event listener to an element that doesn't exist. Looking at the code:

```javascript
// password-toggle.js
const toggleBtn = document.getElementById('password-toggle');
toggleBtn.addEventListener('click', function() {
    // toggle logic
});
```

The button in HTML has id="passwordToggle" (camelCase) but JavaScript looks for "password-toggle" (kebab-case). ID mismatch causes the selector to return null.

**HTML**:
```html
<input type="password" id="password">
<button id="passwordToggle">👁️</button>
```

### Suggested Fix
Fix the ID mismatch:

```javascript
// Option 1: Update JavaScript
const toggleBtn = document.getElementById('passwordToggle');

// Option 2: Update HTML
<button id="password-toggle">👁️</button>
```

Also add null check:
```javascript
const toggleBtn = document.getElementById('passwordToggle');
if (toggleBtn) {
    toggleBtn.addEventListener('click', function() {
        const passwordField = document.getElementById('password');
        if (passwordField.type === 'password') {
            passwordField.type = 'text';
            toggleBtn.textContent = '🙈';
        } else {
            passwordField.type = 'password';
            toggleBtn.textContent = '👁️';
        }
    });
}
```

### Impact
- Poor user experience
- Users cannot verify their password before submitting
- Increases login errors due to typos
- Accessibility issue for users who need to see what they type

### Additional Notes
This affects all password fields on the site (login, registration, password change). The same ID mismatch pattern appears in multiple places.

---

**Reported By**: QA Engineer  
**Date**: 2024-01-16  
**Last Updated**: 2024-01-16