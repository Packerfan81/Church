class Admin::ChildrenController < ApplicationController
  include ChildrenControllerConcern

  private


  def authorized_to_delete?(_child)
    true # Admins can delete any child
  end
end
