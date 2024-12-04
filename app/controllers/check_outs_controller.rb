class CheckOutsController < ApplicationController
  before_action :authenticate_user! # Ensure the user is logged in
  before_action :authorize_check_out! # Ensure only allowed roles can check out children
  skip_before_action :verify_authenticity_token, only: :check_out_by_qr # Allow API requests without CSRF token

  def create
    check_in = CheckIn.find(params[:check_in_id])

    if check_in.update(check_out_time: Time.current)
      check_in.child.update!(checked_in: false)
      ParentMailer.check_out_notification(check_in).deliver_now
      redirect_to redirect_after_check_out, notice: "#{check_in.child.full_name} has been checked out successfully!"
    else
      redirect_to redirect_after_check_out, alert: 'An error occurred while checking out the child.'
    end
  end

   def checkout_tag
    child = Child.find(params[:child_id])

    pdf = CheckoutTagGenerator.new(child).generate

    send_data pdf, filename: "checkout_tag_#{child.id}.pdf", type: "application/pdf", disposition: "inline"
  end

  def check_out_by_qr
    # Extract the data sent by the QR scanner
    qr_data = params[:qr_code_data] # This assumes the scanner sends JSON data with a `qr_code_data` key

    # Parse the QR data to extract information
    child_name, parent_name, parent_contact = parse_qr_data(qr_data)

    # Find the child and their active check-in
    child = Child.find_by(full_name: child_name)
    check_in = child&.check_ins&.where(check_out_time: nil)&.last

    if check_in
      # Update the check-out time and complete the check-out
      check_in.update!(check_out_time: Time.current)

      render json: { message: 'Child checked out successfully.', child: child.full_name }, status: :ok
    else
      render json: { message: 'No active check-in found for this child.', child_name: child_name }, status: :not_found
    end


  private

  def authorize_check_out!
    unless current_user.admin? || current_user.is_a?(User)
      redirect_to root_path, alert: 'You are not authorized to check out children.'
    end
  end

  def redirect_after_check_out
    current_user.admin? ? admin_dashboard_path : root_path
  end

  def parse_qr_data(qr_data)
    # Assuming the QR code contains data like "Child: NAME, Parent: NAME, Contact: PHONE"
    qr_data.split(', ').map { |entry| entry.split(': ').last }
  end

end
end
