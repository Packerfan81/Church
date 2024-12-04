# &nbsp;

| Phase                  | Description                                                                                   | Estimated Timeline (Weeks) |
|------------------------|-----------------------------------------------------------------------------------------------|----------------------------|
| **1. Unit Testing**    | Test individual models, controllers, and helpers in isolation.                                | 1-2                        |
| **2. Integration Testing** | Test the interactions between different components of the system (e.g., parent-child relationship, check-in process). | 2-3                        |
| **3. System Testing**  | Test the complete system from a user's perspective, including the check-in/check-out flow, admin dashboard, and email functionality. | 2-3                        |

---

## Unit Testing

### **Parent Model**

- **Validations**:
  - Required fields: Ensure `first_name`, `last_name`, `email`, and `phone_number` are validated.
  - Validate email format and phone number format.

### **Child Model**

- **Validations**:
  - Test required fields like `first_name`, `last_name`, age range, and grade inclusion.
  - Test the `full_name` method to ensure it outputs the correct format.

### **CheckIn Model**

- **Validations**:
  - Ensure associations with `Child` are correctly established.
  - Validate the presence of required fields.

### **User Model**

- **Methods**:
  - Test the `admin?` method for correct behavior across various user roles.

### **Controllers**

#### *ParentsController*

- Test CRUD operations for creating, viewing, editing, updating, and deleting parent records.
- **Authentication and Error Handling**
  - Handle unauthorized access (e.g., non-admin users attempting to edit or delete).
  - Redirect users when parent records are not found, providing error messages.

#### *ChildrenController*

- Test CRUD operations for child records:
  - Validate user authentication and ensure only authorized users can create or modify child records.
  - Test error handling for missing records or invalid data.
  - Validate the `child_params` method for permitted attributes.

#### *CheckInsController*

- Test creation and update workflows:
  - Validate the generation of name tags and email notifications.
  - Ensure proper error handling and redirection for missing or unauthorized check-in records.

#### *AdminController*

- Test admin-level functionality:
  - Ensure only authorized users can access the dashboard.
  - Verify search, filtering, and management capabilities for parents, children, and check-ins.

#### *SessionsController*

- Test login and logout functionality:
  - Ensure proper session creation and redirection upon login.
  - Handle incorrect login attempts gracefully.

---

## Integration Testing

### **Parent-Child Relationship**

- Test the creation, editing, and deletion of child records associated with a parent.

### **Check-in Process**

- **Flow**:
  - Create a new parent or select an existing one.
  - Add children and verify that records are correctly associated.
  - Generate a name tag and verify email content with embedded QR code.

### **Admin Dashboard**

- Test search, filtering, and editing capabilities for all record types.
- Ensure admin-only functionality is restricted to authorized users.

### **Email and PDF**

- Test email confirmation functionality:
  - Validate QR code inclusion and accuracy.
  - Test PDF generation for name tags with correct formatting and content.

---

## Security Testing

### **Focus Areas**

- **Authorization Rules**:
  - Test `Pundit` policies for all models to ensure proper access control.
- **Email Handling**:
  - Validate the proper configuration and delivery of emails with QR codes.
- **Data Integrity**:
  - Ensure sensitive data is secure and accessible only to authorized users.

---

## Ruby Gems Overview

1. **Pundit**: Handles user authorization by defining policies to control access to specific actions and data.
2. **Prawn**: Generates customizable PDFs for name tags or reports.
3. **Rqrcode**: Simplifies QR code creation for URLs or text.
4. **Ransack**: Provides robust search and filtering functionality.
5. **Devise**: Adds user authentication, including registration, login, and password resets.
6. **Database Cleaner (ActiveRecord)**: Keeps the test database clean and organized for reliable testing**.
