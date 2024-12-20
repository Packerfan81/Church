class CheckInsController < ApplicationController
  def new
    @child = Child.find_by(id: params[:child_id]) # Use `find_by` to avoid exceptions
    if @child.nil?
      redirect_to parents_dashboard_path, alert: 'No children available for check-in.' and return
    end
    @check_in = CheckIn.new
  end

  def create
    @check_in = CheckIn.new(check_in_params)
    @check_in.parent = current_parent if current_parent
    @check_in.full_name = current_parent&.full_name
    @check_in.check_in_time = Time.current

    if @check_in.save
      unless @check_in.child.update(checked_in: true)
        flash.now[:alert] = "Unable to update child status. Please contact support."
        redirect_to parents_dashboard_path
        return
      end

      if handle_notifications_and_tags(@check_in)
        redirect_to parents_dashboard_path, notice: "#{@check_in.child.full_name} has been checked in successfully!"
      else
        flash.now[:alert] = "Check-in was successful, but there was an issue with notifications or tag generation."
        redirect_to parents_dashboard_path
      end
    else
      flash.now[:alert] = "Unable to check in. Please try again."
      render :new unless performed?
    end
  end

  private

  def check_in_params
    params.require(:check_in).permit(:child_id, :note)
  end

  def handle_notifications_and_tags(check_in)
    begin
      ParentMailer.check_in_notification(check_in).deliver_now if check_in.child.parent_email.present?
      CheckoutTagGenerator.new(check_in).generate
      NameTagGenerator.generate(check_in.child)
      true
    rescue StandardError => e
      Rails.logger.error("Check-in notifications or tags failed: #{e.message}")
      false
    end
  end
end
