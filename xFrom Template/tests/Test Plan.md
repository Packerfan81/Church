        Phase	                                        Description	                                                                                  Estimated Timeline (Weeks)		
  1. Unit Testing	        Test individual models, controllers, and helpers in isolation.	                                                                        1-2		
  2. Integration Testing	Test the interactions between different components of the system (e.g., parent-child relationship, check-in process).	                2-3		
  3. System Testing	        Test the complete system from a user's perspective, including the check-in/check-out flow, admin dashboard, and email functionality.	2-3		
# Test Cases

## Unit Testing

- *Parent:*
  - Test validations for required fields, email format, and phone number format.
  
- *Child:*
  - Test validations for required fields, age range, and grade inclusion.
  - Test the `full_name` method.
  
- *CheckIn:*
  - Test validations and associations with Child.  
  
- *User:*
  - Test the `admin?` method.

**Controllers**:

- *ParentsController:*
  - Test actions for creating, viewing, editing, updating, and deleting parents.
  
- *ChildrenController:*
  - Test actions for creating, editing, and updating children.
  
- *CheckInsController:*
  - Test actions for creating, editing, and updating check-ins.
  - Test name tag generation and email sending.
  
- *AdminController:*
  - Test authorization for accessing the dashboard and performing actions within it.
  
- *SessionsController (if custom):*
  - Test the login and logout functionality.

- *Mailers:*

- *CheckInMailer:*
  - Test the `check_in_confirmation` email, verifying:
    - The content.
    - Subject.
    - Recipient.
    - Inclusion of the QR code.

- *Policies (Pundit):*

- Test the authorization rules defined in policies (`ParentPolicy`, `ChildPolicy`, `AdminPolicy` ) to ensure they work as expected.

### Integration Testing

  Parent-Child Relationship:

  Test creating, editing, and deleting children associated with a parent.

**Check-in Process with Email:**

- Test the entire check-in flow, including email confirmation:
  - Creating a new parent or selecting an existing one.
  - Adding children to the parent.
  - Generating a name tag.
  - Sending and verifying the content of the confirmation email with the QR code.

**Check-out Process:**

- Test checking out a child using the QR code or printed tag.

**Admin Dashboard**

- Test the functionality of the admin dashboard, including:
  - Searching.
  - Filtering.
  - Editing.
  - Deleting records in each section (users, check-ins, parents, children).

**System Testing**

**End-to-End Testing with Email and PDF:**
- Perform end-to-end testing of the entire system, focusing on the email and PDF generation aspects.
- Simulate real-world check-in scenarios and verify that the confirmation emails are sent correctly with the QR code.
- Test the PDF name tag generation and ensure the information is displayed accurately.

**Usability Testing:**

- Evaluate the overall user experience, including:
  - Ease of use.
  - Clarity of instructions.
  - Error handling.

 **Performance Testing:**

- Test the system's performance under different load conditions, especially focusing on the impact of email sending and PDF generation.

#### Security Testing:

- **Identify and address any potential security vulnerabilities.**

-**Focus Areas**

**Email Functionality:**

- **Thoroughly test the email sending process, including:**
  - Correct recipient, subject, and content.
  - Proper QR code generation and inclusion in the email.
  - Error handling for failed email deliveries.

**PDF Generation:**

- Test the name tag PDF generation, ensuring:
  - Accurate display of child information, classroom assignment, parent info, allergies, medical needs, and emergency contact.
  - Correct formatting and layout of the name tag.



  