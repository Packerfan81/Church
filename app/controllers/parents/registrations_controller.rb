class Parents::RegistrationsController < Devise::RegistrationsController

  def sign_up_params
    params.require(:parent).permit(:first_name, :last_name, :email, :phone_number, :password, :password_confirmation)
  end


  def account_update_params
    params.require(:parent).permit(:first_name, :last_name, :email, :phone_number, :password, :password_confirmation, :current_password)
  end
end

  private

  def sign_up_params
    params.require(:parent).permit(:email, :password, :password_confirmation, :first_name, :last_name, :phone_number)
  end

