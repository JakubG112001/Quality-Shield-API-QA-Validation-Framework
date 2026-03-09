# Bug Report - File Upload Fails Without Error Message

## Bug ID: BUG-006

### Summary
Large file uploads fail silently with no error message shown to user

### Severity
- [ ] Critical
- [x] High
- [ ] Medium
- [ ] Low

### Environment
- **Browser**: Chrome 120.0.6099.130
- **OS**: Windows 11
- **Device**: Desktop
- **Screen Resolution**: 1920x1080

### Steps to Reproduce
1. Navigate to profile settings at `https://example-site.com/profile/edit`
2. Click "Upload Profile Picture"
3. Select an image file larger than 2MB (e.g., 3.5MB image)
4. Click "Save Changes"
5. Observe the result

### Expected Result
- If file is too large, show error message: "File size must be under 2MB"
- Highlight the file input field in red
- Prevent form submission
- Allow user to select a different file

### Actual Result
- Form appears to submit (loading spinner shows)
- Page refreshes after 2-3 seconds
- No profile picture is uploaded
- No error message displayed
- User has no idea what went wrong

### Visual Evidence
**Network Activity**:
```
Request URL: https://example-site.com/api/profile/upload
Status: 413 Payload Too Large
Response: {"error": "File size exceeds 2MB limit"}
```

**Console Errors**:
No errors in console - the 413 response is not being handled

### Reproducibility
- [x] Always (100%)
- [ ] Often (75%)
- [ ] Sometimes (50%)
- [ ] Rarely (25%)

**Testing Results**:
- 1.5MB file - uploads successfully
- 2.0MB file - uploads successfully  
- 2.1MB file - fails silently
- 5.0MB file - fails silently

### Root Cause Analysis
The backend correctly rejects files over 2MB with a 413 status code, but the frontend doesn't handle this error. The JavaScript only handles 200 OK responses:

```javascript
// Current code
fetch('/api/profile/upload', {
    method: 'POST',
    body: formData
})
.then(response => response.json())
.then(data => {
    showSuccess('Profile updated!');
})
.catch(error => {
    // This only catches network errors, not HTTP error codes
    console.error(error);
});
```

The code doesn't check `response.ok` or handle non-200 status codes.

### Suggested Fix
Add proper error handling:

```javascript
fetch('/api/profile/upload', {
    method: 'POST',
    body: formData
})
.then(response => {
    if (!response.ok) {
        return response.json().then(err => {
            throw new Error(err.error || 'Upload failed');
        });
    }
    return response.json();
})
.then(data => {
    showSuccess('Profile updated!');
})
.catch(error => {
    showError(error.message);
});
```

Also add client-side validation before upload:

```javascript
const fileInput = document.getElementById('profile-picture');
const maxSize = 2 * 1024 * 1024; // 2MB

fileInput.addEventListener('change', function() {
    if (this.files[0].size > maxSize) {
        showError('File size must be under 2MB');
        this.value = ''; // Clear the input
    }
});
```

### Impact
- Users don't know why their upload failed
- Repeated failed attempts without understanding the issue
- Frustration and potential abandonment
- Support tickets asking "why won't my picture upload?"
- Wastes bandwidth uploading files that will be rejected

### Additional Notes
The same issue exists for document uploads in other parts of the site:
- Resume upload on job applications
- Attachment upload in support tickets
- Product image upload for sellers

All file upload functionality needs error handling review.

---

**Reported By**: QA Engineer  
**Date**: 2024-01-17  
**Last Updated**: 2024-01-17