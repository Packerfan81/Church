# &nbsp;

| Phase | Description | Estimated Timeline (Weeks) |
|---|---|---|
| 1. Unit Testing | Test individual models, controllers, and helpers in isolation. | 1-2 |
| 2. Integration Testing | Test the interactions between different components of the system (e.g., parent-child relationship, check-in process). | 2-3 |
| 3. System Testing | Test the complete system from a user's perspective, including the check-in/check-out flow, admin dashboard, and email functionality. | 2-3 |

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
    - Pundit authentication

          ```ruby
            @parent = Parent.new(parent_params)
            if @parent.save
            redirect_to new_parent_child_path(@parent), notice: "Parent created successfully. Please add your child/children."

          ```

          This line creates a new parent record

          ```ruby
            Not Found
            rescue ActiveRecord::RecordNotFound
            redirect_to parents_path, alert: "Parent not found."
          ```

           This handles an error that might occur if a parent record is not found in the database. If this happens, the application redirects the user to the parents page and shows an alert message.

          ```ruby
            Not Authurized
            rescue Pundit::NotAuthorizedError
            redirect_to parents_path, alert: "You are not authorized to edit this parent."
            rescue ActiveRecord::RecordNotFound
          ```

          This handles an error that occurs if a non admin user is trying to edit a parent record. If this happens, the application redirects the user to the parents page and shows an alert message.

          ```ruby
            redirect_to parents_path, alert: "Parent not found."
            rescue Pundit::NotAuthorizedError
            redirect_to parents_path, alert: "You are not authorized to update this parent."
          ```

          This handles an error if a non admin user is trying to update a parent record. If this happens, the application redirects the user to the parents page and shows an alert message.

          ```ruby
            destroy
            @parent = find_and_authorize_parent
            if @parent.destroy
            redirect_to parents_path, notice: "Parent was successfully deleted."
            else
            redirect_to parents_path, alert: "Parent could not be deleted."
            end

            rescue ActiveRecord::RecordNotFound
            redirect_to parents_path, alert: "Parent not found."
            rescue Pundit::NotAuthorizedError
            redirect_to parents_path, alert: "You are not authorized to delete this parent."
            end
          ```

          These lines finds locates the parents and if found it will delete it if the the user is an admin user, if the parent is not found or user not and admin the parent is not deleted.

          ```ruby
            private

            def find_and_authorize_parent
            parent = Parent.find(params[:id])
            authorize parent
            parent
            end

            def parent_params
            params.require(:parent).permit(:first_name, :last_name, :phone_number, :email)

            @parent = Parent.new(parent_params): This line creates a new parent record. Imagine it like creating a new form for a parent, and parent_params are the details entered into that form (like first name, last name, etc.).
          ```

          This method defines the parameters used in the controller and also helps find the parent record. The params keeps from unauthorized users from entering information.

- *ChildrenController:*
  - Test actions for creating, editing, and updating children.

        ```ruby
          before_action :authenticate_user!
          @parent = Parent.find(params[:parent_id])
          @child = @parent.children.build

          def edit
          @child = Child.find(params[:id])
          authorize @child
          rescue ActiveRecord::RecordNotFound
          redirect_to parents_path, alert: "Child not found."
          end
        ```

        These lines handle the creation and editing of child records, ensuring that only logged-in and authorized users can perform these actions.
        Also includes error handling to manage situations where a child record is not found.

        ```ruby
          def update
          @child = Child.find(params[:id])
          authorize @child
          if @child.update(child_params)
          flash[:notice] = "Child information updated successfully."
          redirect_to @child
          else
          render :edit
          end
          rescue ActiveRecord::RecordNotFound
          redirect_to parents_path, alert: "Child not found."
          end
        ```

        These lines looks for a child record, checks to see if the user is authorized to perform these actions if they are and the information is formatted accordingly, it will update the child record, if the information is not formatted accordingly it will redirect back to the child record.  If the child record is not found it will redirect back to the parents page.

        ```ruby
          private

          def child_params
          params.require(:child).permit(:first_name, :last_name, :age, :grade, :food_allergies, :special_medical_needs, :emergency_contact, :classroom_id).tap do |p| p.require([:first_name, :last_name])
        ```

        This method defines the parameters to successfully create a child record

- *CheckInsController:*

- Test actions for creating, editing, and updating check-ins.

      ```ruby
        before_action :authenticate_user!
        before_action :set_check_in, only: [:edit, :update]
      ```
      These lines makes authenticated the user and runs the set_check_in action

      ```ruby
        @check_in = CheckIn.new(check_in_params)
        if @check_in.save

        generate_name_tag(@check_in)

        # Send email (if chosen)
        send_check_in_email(@check_in) if @check_in.send_email

        redirect_to check_in_path(@check_in), notice: "Check-in successful!"
        else
        render :new
      ```
          These lines the save operation is successful, generates a name tag for  the check-in and then sends an email notification (if the user opted in). Then it redirects the user to the check-in page with a success message.  If not it creates a new template with validations errors.

      ```ruby
        authorize @check_in # Authorize using Pundit
        end

        def update
        authorize @check_in # Authorize using Pundit
        if @check_in.update(check_in_params)
        redirect_to check_in_path(@check_in), notice: "Check-in updated successfully."
        else
        render :edit
        end
        end
      ```

      ```ruby
        private

        def set_check_in
        @check_in = CheckIn.find(params[:id])
        rescue ActiveRecord::RecordNotFound
        redirect_to check_ins_path, alert: "Check-in not found."
        end

        def check_in_params
        params.require(:check_in).permit(:child_id, :send_email)
        end
      ```
          This methods in manages check-ins, set_check_in finds a specific check-in record by its ID, or redirects the user if it doesn't exist. check_in_params filters the data submitted through a form to only allow the child_id and send_email fields.

- Test name tag generation and email sending.

      ```ruby
      generate_name_tag(check_in)
      pdf = Prawn::Document.new
      pdf.text check_in.child.full_name, size: 24, align: :center
      pdf.text "Classroom: #{check_in.child.classroom}", size: 18, align: :center
        send_data pdf.render, filename: "#{check_in.child.full_name}_name_tag.pdf", type: "application/pdf"
      end

      def send_check_in_email(check_in)
      CheckInMailer.check_in_confirmation(check_in).deliver_later
      end
      ```
        This gives the specifications for the pdf tag and sends an email if the parents have selected that option.

- *AdminController:*

- Test authorization for accessing the dashboard and performing actions within it.
  
      ```ruby
      before_action :authenticate_user!
      before_action :authorize_admin

      @parents = Parent.all
      @children = Child.all
      @check_ins = CheckIn.all

      @user_search = User.ransack(params[:q])
      @users = @user_search.result

      @check_in_search = CheckIn.ransack(params[:q])
      @check_ins = @check_in_search.result

      @parent_search = Parent.ransack(params[:q])
      @parents = @parent_search.result

      @child_search = Child.ransack(params[:q])
      @children = @child_search.result
      rescue Pundit::NotAuthorizedError
      redirect_to root_path, alert: "You are not authorized to access the admin dashboard."


      private

      def authorize_admin
      authorize :admin, :dashboard?
      ```
Ensures the logged in user is an admin so that is authorized to access the admin dashboard.  Allows the Admin to access the records for parents, childrens, users, and currently checked in children. If not authorized the redirects to home page with error message.
        

- *SessionsController :
  - Test the login and logout functionality.
    
  ```ruby
        helper Devise::Controllers::Helpers
        def new
          super # This calls the default 'new' action from Devise::SessionsController
        end
  ```
  
This part of the code ensures that your login page uses the standard Devise login form and behavior, but it also allows you to customize it further if needed. You can add code before or after the super call to modify the login process.

  ```ruby
    def create
    self.resource = warden.authenticate!(auth_options) # Authenticate the user
    set_flash_message!(:notice, :signed_in) # Set a success flash message
    sign_in(resource_name, resource) # Sign in the user
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource) # Redirect after login
    end
  
    self.resource = warden.authenticate!(auth_options): This line uses a library called Warden, which is  used with Devise, to authenticate the user based on the provided credentials (like username and password).
  ```
      
This part of the code handles the entire proceess of verifing user credentials, establishing the session, and directing to the user to the correct page if they login successfully.
  
- *Mailers:*

- *Application_Mailer:*
  ```ruby
        class CheckInMailer < ApplicationMailer
  default from: 'jaye.engelhardt@gmail.com' # Replace with your actual church email

  def check_in_confirmation(check_in)
    @check_in = check_in
    @child = check_in.child
    @parent = @child.parent

    # Generate QR code
    qr_code_data = "https://your-church-website.com/check_ins/#{@check_in.id}/edit"
    qr_code = RQRCode::QRCode.new(qr_code_data, size: 12, level: :h)
    @qr_code_svg = qr_code.as_svg(offset: 0, color: '000', shape_rendering: 'crispEdges')

    begin
      mail(to: @parent.email, subject: 'Check-in Confirmation') do |format|
        format.html { render layout: 'mailer' }
      end
    rescue StandardError => error
      # Handle email delivery errors (log, notify admin, etc.)
      logger.error "Error sending check-in confirmation email: #{error.message}"
    end
  end
  end
  ```
  This code gets information from the checkin controller, creates a QR code with the appropriate info and then it sends the info to the parents.  If any problems happen sending the email it will notify the user.

- *Policies (Pundit):*

- Test the authorization rules defined in policies (`ParentPolicy`, `ChildPolicy`, `AdminPolicy` ) to ensure they work as expected.

```ruby
  class AdminDashboardController < ApplicationController
  def show
    authorize AdminDashboardPolicy # or authorize(AdminDashboardPolicy.new(current_user))
    # ... code to render the dashboard ...
  end
end
```
This policy ensures only users with admin access have permission to view the Admin Dashboard

```ruby
class AdminPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def create?
    user.admin?
  end
end
```

This policy ensures only users with admin permissions can access the authorized information.

```ruby
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end

    private

    attr_reader :user, :scope
  end
end
```

This code sets up the basic stucture and default authorization rules.

```ruby
# app/policies/check_in_policy.rb
class CheckInPolicy < ApplicationPolicy
  # Define who can perform various actions on CheckIn records

  def create?
    user.present? # Any logged-in user can create a check-in
  end

  def edit?
    user.admin? # Only admins can edit check-ins
  end

  def update?
    edit? # Same rules apply for updating as for editing
  end

  def destroy?
    user.admin? # Only admins can delete check-ins
  end
end
```

  This policy defines what different users can do with check-ins

```ruby
# app/policies/parent_policy.rb
class ParentPolicy < ApplicationPolicy
  def edit?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end
end
```

  This policy defines what parents can do once check-in is complete

## Integration Testing

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

## Security Testing

- **Identify and address any potential security vulnerabilities.**

-**Focus Areas**

**Email Functionality:**

- **Thoroughly test the email sending process, including:**
  - Correct recipient, subject, and content.
  - Proper QR code generation and inclusion in the email.
  - Error handling for failed email deliveries.

**PDF Generation:**

- Test the name tag PDF generation, ensuring:
  - Accurate display of child information, classroom assignment, parent info, allergies, medical     needs, and emergency contact.
  - Correct formatting and layout of the name tag.

## Ruby Gems

**Pundit**
  - Pundit helps you control which users can see or modify different parts of your application. It uses policy objects to define authorization rules for your models, keeping your code organized and easy to maintain.

**Prawn**
  - Prawn is a ruby library that lets you generate PDF documents.  It can be used to control the way you want your PDFs to look

**Rqrcode**
  - Rqrcode is a Ruby gem that lets you easily create QR codes in your applications. You can generate QR codes for various data types, like URLs or text, and customize their size and appearance.

 **Ransack**
  - Ransack is a Ruby gem that provides an easy way to add advanced search capabilities to your Rails applications. It allows your users to search and filter data based on various criteria, like matching text, comparing numbers, or checking dates.

 **Devise**
  - Devise is a Ruby gem that makes it easy to add user authentication to your Rails applications. It handles things like user registration, login, logout, and password resets. 

  **Database cleaner active record**
  - Ruby gem that helps you keep your test database clean and organized. It provides strategies for cleaning your database using ActiveRecord, ensuring each test starts clean and avoids conflicts between tests.
