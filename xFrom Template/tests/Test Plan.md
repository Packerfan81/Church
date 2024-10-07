| Phase | Description | Estimated Timeline (Weeks) |
|---|---|---|
| 1. Unit Testing | Test individual models, controllers, and helpers in isolation. | 1-2 |
| 2. Integration Testing | Test the interactions between different components of the system (e.g., parent-child relationship, check-in process). | 2-3 |
| 3. System Testing | Test the complete system from a user's perspective, including the check-in/check-out flow, admin dashboard, and email functionality. | 2-3 |

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
  Test actions for creating, editing, and updating children.

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
        @check_in = CheckIn.new(check_in_params)
        if @check_in.save

        generate_name_tag(@check_in)

        Send email (if chosen)

        send_check_in_email(@check_in) if @check_in.send_email

        redirect_to check_in_path(@check_in), notice: "Check-in successful!"
        else
        render :new

        authorize @check_in # Authorize using Pundit
        end

        def update
        authorize @check_in # Authorize using Pundit
        if @check_in.update(check_in_params)
        redirect_to check_in_path(@check_in), notice: "Check-in updated successfully."
        else
        render :edit
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

- Test name tag generation and email sending.

      generate_name_tag(check_in)
      pdf = Prawn::Document.new
      pdf.text check_in.child.full_name, size: 24, align: :center
      pdf.text "Classroom: #{check_in.child.classroom}", size: 18, align: :center
        send_data pdf.render, filename: "#{check_in.child.full_name}_name_tag.pdf", type: "application/pdf"
      end

    def send_check_in_email(check_in)
    CheckInMailer.check_in_confirmation(check_in).deliver_later
    end

- *AdminController:*
  - Test authorization for accessing the dashboard and performing actions within it.
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

- *SessionsController (if custom):*
  - Test the login and logout functionality.
        helper Devise::Controllers::Helpers
        def new
          super # This calls the default 'new' action from Devise::SessionsController
        end

  def create
    self.resource = warden.authenticate!(auth_options) # Authenticate the user
    set_flash_message!(:notice, :signed_in) # Set a success flash message
    sign_in(resource_name, resource) # Sign in the user
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource) # Redirect after login
  end

- *Mailers:*

- *CheckInMailer:*
  - Test the `check_in_confirmation` email, verifying:
    - The content.
        default from: '<jaye.engelhardt@gmail.com>'
        Replace with your actual church email

        def check_in_confirmation(check_in)
 @check_in = check_in
 @child = @check_in.child
 @parent = @child.parent

 generate_qr_code

 mail(to: @parent.email, subject: 'Check-in Confirmation') do |format|
 format.html { render layout: 'mailer' }
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

#### Security Testing

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
  - Correct formatting and layout of the name tag.        Phase                                         Description                                                                                   Estimated Timeline (Weeks)
  1. Unit Testing         Test individual models, controllers, and helpers in isolation.                                                                         1-2
  2. Integration Testing Test the interactions between different components of the system (e.g., parent-child relationship, check-in process).                 2-3
  3. System Testing         Test the complete system from a user's perspective, including the check-in/check-out flow, admin dashboard, and email functionality. 2-3

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
    - Pundit authentication

          ```ruby
          @parent = Parent.new(parent_params)
          if @parent.save
          redirect_to new_parent_child_path(@parent), notice: "Parent created successfully. Please add your child/children."
          ```

          Not Found
          rescue ActiveRecord::RecordNotFound
          redirect_to parents_path, alert: "Parent not found."

          Not Authurized
          rescue Pundit::NotAuthorizedError
          redirect_to parents_path, alert: "You are not authorized to edit this parent."
          rescue ActiveRecord::RecordNotFound

          redirect_to parents_path, alert: "Parent not found."
          rescue Pundit::NotAuthorizedError
          redirect_to parents_path, alert: "You are not authorized to update this parent."

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

      private

      def find_and_authorize_parent
      parent = Parent.find(params[:id])
      authorize parent
      parent
      end

     def parent_params
     params.require(:parent).permit(:first_name, :last_name, :phone_number, :email)

         -
- *ChildrenController:*
  - Test actions for creating, editing, and updating children.
      before_action :authenticate_user!
        @parent = Parent.find(params[:parent_id])
        @child = @parent.children.build

        def edit
        @child = Child.find(params[:id])
        authorize @child
        rescue ActiveRecord::RecordNotFound
        redirect_to parents_path, alert: "Child not found."
        end

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

private

    def child_params
    params.require(:child).permit(:first_name, :last_name, :age, :grade, :food_allergies, :special_medical_needs, :emergency_contact, :classroom_id).tap do |p| p.require([:first_name, :last_name])

- *CheckInsController:*
  - Test actions for creating, editing, and updating check-ins.
    before_action :authenticate_user!
    before_action :set_check_in, only: [:edit, :update]
     @check_in = CheckIn.new(check_in_params)
    if @check_in.save

      generate_name_tag(@check_in)

    # Send email (if chosen)

      send_check_in_email(@check_in) if @check_in.send_email

      redirect_to check_in_path(@check_in), notice: "Check-in successful!"
    else
      render :new

      authorize @check_in # Authorize using Pundit
  end

  def update
    authorize @check_in # Authorize using Pundit
    if @check_in.update(check_in_params)
      redirect_to check_in_path(@check_in), notice: "Check-in updated successfully."
    else
      render :edit
    end

    private

  def set_check_in
    @check_in = CheckIn.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to check_ins_path, alert: "Check-in not found."
  end

 def check_in_params
    params.require(:check_in).permit(:child_id, :send_email)
  end

- Test name tag generation and email sending.
      generate_name_tag(check_in)
      pdf = Prawn::Document.new
      pdf.text check_in.child.full_name, size: 24, align: :center
      pdf.text "Classroom: #{check_in.child.classroom}", size: 18, align: :center
        send_data pdf.render, filename: "#{check_in.child.full_name}_name_tag.pdf", type: "application/pdf"
      end

    def send_check_in_email(check_in)
    CheckInMailer.check_in_confirmation(check_in).deliver_later
    end

- *AdminController:*
  - Test authorization for accessing the dashboard and performing actions within it.
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

- *SessionsController (if custom):*
  - Test the login and logout functionality.
        helper Devise::Controllers::Helpers
        def new
          super # This calls the default 'new' action from Devise::SessionsController
        end

  def create
    self.resource = warden.authenticate!(auth_options) # Authenticate the user
    set_flash_message!(:notice, :signed_in) # Set a success flash message
    sign_in(resource_name, resource) # Sign in the user
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource) # Redirect after login
  end

- *Mailers:*

- *CheckInMailer:*
  - Test the `check_in_confirmation` email, verifying:
    - The content.
        default from: '<jaye.engelhardt@gmail.com>'
        Replace with your actual church email

        def check_in_confirmation(check_in)
 @check_in = check_in
 @child = @check_in.child
 @parent = @child.parent

 generate_qr_code

 mail(to: @parent.email, subject: 'Check-in Confirmation') do |format|
 format.html { render layout: 'mailer' }
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

#### Security Testing

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
