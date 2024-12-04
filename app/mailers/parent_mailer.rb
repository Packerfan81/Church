class ParentMailer < ApplicationMailer
  default from: 'no-reply@yourdomain.com'
  layout false

  def check_in_notification(check_in)
    @check_in = check_in.is_a?(CheckIn) ? check_in : CheckIn.find_by(id: check_in)

    unless @check_in
      Rails.logger.error "CheckIn record not found for ID: #{check_in}"
      return
    end

    @parent = @check_in.parent
    @child = @check_in.child
    @check_in_time = @check_in.check_in_time

    unless @parent && @child
      Rails.logger.error "CheckIn ##{@check_in.id}: Parent or child missing for email notification."
      return
    end

     begin
       @qr_code_png = qrcode.as_png(
      resize_gte_to: false,
      resize_exactly_to: false,
      fill: 'white',
      color: 'black',
      size: 240, # Adjust the size as needed
      border_modules: 4,
      module_px_size: 6
    )

    attachments.inline['qr_code.png'] = @qr_code_png.to_s

       mail(to: @parent.email, subject: 'Child Check-In Notification')
     rescue StandardError => e
      Rails.logger.error "Failed to send check-in notification email: #{e.message}"
     end
  end

  def check_out_notification(check_in)
    @parent = check_in.parent
    @child = check_in.child
    @check_out_time = check_in.check_out_time

    unless @parent && @child
      Rails.logger.error "CheckIn ##{check_in.id}: Parent or child missing for check-out notification."
      return
    end

    mail(to: @parent.email, subject: 'Child Check-Out Notification')
  rescue StandardError => e
    Rails.logger.error "Failed to send check-out notification email: #{e.message}"
  end
end
