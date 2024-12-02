class ParentMailer < ApplicationMailer
  default from: 'no-reply@yourdomain.com'

  def check_in_notification(check_in)
    @parent_name = check_in.parent.full_name
    @child = check_in.child
    @check_in_time = check_in.check_in_time

    qr_code_data = "Child: #{@child.full_name}, Parent: #{@parent.full_name}, Contact: #{@parent.phone_number}"
    qrcode = RQRCode::QRCode.new(qr_code_data)
    @qr_code_svg = qrcode.as_svg(module_size: 4, standalone: true)
    mail(to: @parent.email, subject: 'Child Check-In Notification')
  end

  def check_out_notification(check_in)
    @parent = check_in.parent
    @child = check_in.child
    @check_out_time = check_in.check_out_time
    mail(to: @parent.email, subject: 'Child Check-Out Notification')
  end
end