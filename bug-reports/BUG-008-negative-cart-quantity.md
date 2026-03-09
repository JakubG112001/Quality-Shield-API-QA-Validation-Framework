# Bug Report - Shopping Cart Quantity Accepts Negative Numbers

## Bug ID: BUG-008

### Summary
Shopping cart allows negative quantity values, resulting in negative total price

### Severity
- [x] Critical
- [ ] High
- [ ] Medium
- [ ] Low

### Environment
- **Browser**: Chrome 120.0.6099.130
- **OS**: Windows 11
- **Device**: Desktop
- **Screen Resolution**: 1920x1080

### Steps to Reproduce
1. Navigate to `https://example-site.com/shop`
2. Add any product to cart
3. Go to cart page at `https://example-site.com/cart`
4. In the quantity field, manually type "-5"
5. Press Tab or click outside the field
6. Observe the cart total

### Expected Result
- Quantity field should only accept positive integers (1, 2, 3, etc.)
- Minimum value should be 1
- If user enters 0 or negative number, show error or reset to 1
- Cart total should never be negative

### Actual Result
- Quantity field accepts "-5"
- Cart total becomes negative: -$149.95
- "Proceed to Checkout" button remains enabled
- User can attempt to checkout with negative total

### Visual Evidence
**Cart Display**:
```
Product: Wireless Mouse
Price: $29.99
Quantity: -5
Subtotal: -$149.95

Total: -$149.95
```

**Network Request**:
```json
PUT /api/cart/update
{
  "productId": 123,
  "quantity": -5
}

Response: 200 OK
{
  "success": true,
  "cartTotal": -149.95
}
```

### Console Errors
No errors - the system accepts negative values

### Reproducibility
- [x] Always (100%)
- [ ] Often (75%)
- [ ] Sometimes (50%)
- [ ] Rarely (25%)

**Additional Testing**:
- Quantity: 0 - Accepted, total becomes $0.00
- Quantity: -1 - Accepted, total becomes -$29.99
- Quantity: -100 - Accepted, total becomes -$2,999.00
- Quantity: 999999 - Accepted (no maximum limit)

### Root Cause Analysis
The quantity input has no validation constraints:

**Current HTML**:
```html
<input type="number" 
       class="quantity-input" 
       value="1" 
       name="quantity">
```

**Backend API** also lacks validation:
```python
def update_cart(product_id, quantity):
    cart_item = CartItem.query.get(product_id)
    cart_item.quantity = quantity  # No validation!
    cart_item.total = cart_item.price * quantity
    db.commit()
    return {"success": True, "cartTotal": calculate_total()}
```

The system blindly accepts any number without checking if it's positive.

### Suggested Fix

**Frontend - HTML**:
```html
<input type="number" 
       class="quantity-input" 
       value="1" 
       min="1" 
       max="99"
       name="quantity"
       required>
```

**Frontend - JavaScript**:
```javascript
document.querySelectorAll('.quantity-input').forEach(input => {
    input.addEventListener('change', function() {
        let value = parseInt(this.value);
        
        if (isNaN(value) || value < 1) {
            this.value = 1;
            showError('Quantity must be at least 1');
        } else if (value > 99) {
            this.value = 99;
            showError('Maximum quantity is 99');
        }
        
        updateCart(this.dataset.productId, this.value);
    });
});
```

**Backend - Python**:
```python
def update_cart(product_id, quantity):
    # Validate quantity
    if not isinstance(quantity, int):
        return {"error": "Quantity must be an integer"}, 400
    
    if quantity < 1:
        return {"error": "Quantity must be at least 1"}, 400
    
    if quantity > 99:
        return {"error": "Maximum quantity is 99"}, 400
    
    # Check stock availability
    product = Product.query.get(product_id)
    if quantity > product.stock:
        return {"error": f"Only {product.stock} items available"}, 400
    
    cart_item = CartItem.query.get(product_id)
    cart_item.quantity = quantity
    cart_item.total = cart_item.price * quantity
    db.commit()
    
    return {"success": True, "cartTotal": calculate_total()}, 200
```

### Impact
- **Critical Security Issue**: Users could potentially exploit negative pricing
- **Revenue Loss**: Negative totals could result in the company owing money
- **Payment Processing**: Unclear how payment gateway handles negative amounts
- **Data Integrity**: Invalid cart data in database
- **Business Logic Failure**: Violates fundamental e-commerce rules

### Additional Notes
**Attempted Checkout Test**: 
I attempted to proceed to checkout with negative total. The payment page loaded but showed $0.00 instead of the negative amount. This suggests the payment system has some validation, but the cart system does not.

**Related Issues**:
- No maximum quantity limit (can add 999,999 items)
- No stock availability check (can add more than available)
- Quantity can be set to 0 (should remove item instead)

This is a critical issue that needs immediate attention. The lack of basic input validation on a financial transaction system is a serious problem.

---

**Reported By**: QA Engineer  
**Date**: 2024-01-18  
**Last Updated**: 2024-01-18  
**Priority**: URGENT - Financial Impact