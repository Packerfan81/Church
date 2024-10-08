class CheckInsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_check_in, only: [:edit, :update]
  def new

  end

  def create
    @check_in = CheckIn.new(check_in_params)
    if @check_in.save

      generate_name_tag(@check_in)

      # Send email (if chosen)
      send_check_in_email(@check_in) if @check_in.send_email

      redirect_to check_in_path(@check_in), notice: "Check-in successful!"
    else
      render :new
    end
  end

  def edit
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

  private

  def set_check_in
    @check_in = CheckIn.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to check_ins_path, alert: "Check-in not found."
  end

  def check_in_params
    params.require(:check_in).permit(:child_id, :send_email)
  end

  def generate_name_tag(check_in)
   pdf = Prawn::Document.new
    pdf.text check_in.child.full_name, size: 24, align: :center
    pdf.text "Classroom: #{check_in.child.classroom}", size: 18, align: :center
        send_data pdf.render, filename: "#{check_in.child.full_name}_name_tag.pdf", type: "application/pdf"
  end

  def send_check_in_email(check_in)
    CheckInMailer.check_in_confirmation(check_in).deliver_later
  end
end