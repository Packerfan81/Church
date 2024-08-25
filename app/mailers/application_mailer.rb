class ApplicationMailer < ActionMailer::Base
  default from: 'jaye.engelhardt@gmail.com' # Replace with your actual church email

 def check_in_confirmation(check_in)
 @check_in = check_in
 @child = @check_in.child
 @parent = @child.parent

 generate_qr_code

 mail(to: @parent.email, subject: 'Check-in Confirmation') do |format|
 format.html { render layout: 'mailer' }
 end

 rescue StandardError => error
  handle_email_error(error)
 end

 private

 def generate_qr_code
  qr_code_data = "https://your-church-website.com/check_ins/#{@check_in.id}/edit"
  qr_code = RQRCode::QRCode.new(qr_code_data, size: 12, level: :h)
  @qr_code_svg = qr_code.as_svg(offset: 0, color: '000', shape_rendering: 'crispEdges')
 end

 def handle_email_error(error)
  logger.error "Error sending check-in confirmation email: #{error.message}"
  notify_administrator(error) # Optional: Implement this method to notify an admin
 end

 def notify_administrator(error)
  # Implementation for notifying an administrator (e.g., via email, error tracking service, etc.)
 end
end