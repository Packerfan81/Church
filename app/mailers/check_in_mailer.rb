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
