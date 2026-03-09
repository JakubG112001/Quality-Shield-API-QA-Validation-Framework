# Bug Report - Date Picker Allows Past Dates for Future Events

## Bug ID: BUG-007

### Summary
Event booking form accepts past dates, allowing users to book events that already occurred

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
1. Navigate to `https://example-site.com/events/book`
2. Select any event from the list
3. Click on the date picker for "Event Date"
4. Select a date from last month (e.g., December 15, 2023)
5. Fill in other required fields
6. Click "Book Event"
7. Observe that booking is accepted

### Expected Result
- Date picker should disable all past dates
- Only today and future dates should be selectable
- If user somehow submits a past date, show error: "Event date must be in the future"
- Form should not submit with invalid date

### Actual Result
- Date picker allows selection of any date, including past dates
- Form submits successfully with past date
- Confirmation email sent for event that already passed
- Booking appears in user's dashboard

### Visual Evidence
**Successful Booking Response**:
```json
{
  "success": true,
  "bookingId": 12847,
  "eventDate": "2023-12-15",
  "message": "Event booked successfully"
}
```

**Database Entry**:
```sql
SELECT * FROM bookings WHERE booking_id = 12847;
-- event_date: 2023-12-15 (past date)
-- status: confirmed
```

### Console Errors
No errors - validation is completely missing

### Reproducibility
- [x] Always (100%)
- [ ] Often (75%)
- [ ] Sometimes (50%)
- [ ] Rarely (25%)

### Root Cause Analysis
The date picker has no minimum date restriction, and there's no validation on either frontend or backend.

**Current HTML**:
```html
<input type="date" id="event-date" name="eventDate">
```

**Should be**:
```html
<input type="date" id="event-date" name="eventDate" min="2024-01-18">
```

Backend also lacks validation:
```python
# Current (no validation)
def create_booking(event_date, user_id):
    booking = Booking(event_date=event_date, user_id=user_id)
    db.save(booking)
    return booking

# Should validate
def create_booking(event_date, user_id):
    if event_date < datetime.now().date():
        raise ValueError("Event date cannot be in the past")
    booking = Booking(event_date=event_date, user_id=user_id)
    db.save(booking)
    return booking
```

### Suggested Fix

**Frontend - HTML**:
```html
<input type="date" 
       id="event-date" 
       name="eventDate" 
       min="" 
       required>

<script>
// Set min to today's date
document.getElementById('event-date').min = new Date().toISOString().split('T')[0];
</script>
```

**Frontend - JavaScript Validation**:
```javascript
form.addEventListener('submit', function(e) {
    const selectedDate = new Date(document.getElementById('event-date').value);
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    
    if (selectedDate < today) {
        e.preventDefault();
        showError('Event date must be in the future');
        return false;
    }
});
```

**Backend - Python**:
```python
from datetime import datetime, date

def create_booking(event_date_str, user_id):
    event_date = datetime.strptime(event_date_str, '%Y-%m-%d').date()
    
    if event_date < date.today():
        return {"error": "Event date cannot be in the past"}, 400
    
    booking = Booking(event_date=event_date, user_id=user_id)
    db.save(booking)
    return {"success": True, "bookingId": booking.id}, 200
```

### Impact
- Users can book events that already happened
- Wasted resources processing invalid bookings
- Confusion when users realize event has passed
- Refund requests and support tickets
- Data integrity issues in booking system
- Potential revenue loss from invalid bookings

### Additional Notes
Similar issue exists in other date-related forms:
- Appointment scheduling (allows past dates)
- Reservation system (allows past dates)
- Subscription renewal (allows past dates)

All date inputs across the site need validation review.

**Business Logic Issue**: The system also doesn't check if the selected event date matches an actual event occurrence. Users can book events on dates when they don't exist.

---

**Reported By**: QA Engineer  
**Date**: 2024-01-18  
**Last Updated**: 2024-01-18