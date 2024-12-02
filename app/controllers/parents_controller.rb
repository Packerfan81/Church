# app/controllers/parents_controller.rb
class ParentsController < ApplicationController

  def update_preferences
    current_parent.update(check_out_preference: params[:check_out_preference].join(', '))
    redirect_to parents_dashboard_path, notice: 'Check-out preference updated successfully.'
  rescue => e
    redirect_to parents_dashboard_path, alert: 'Failed to update preferences.'
  end
end

def update
    @parent = Parent.find(params[:id])
  if @parent.update(parent_params)
      # Handle successful update
  else
      # Handle update errors
  end

  def delete

  end


private
  def parent_params
    params.require(:parent).permit(:check_out_preference)
  end
end