class User < Admin
  def admin?
    self.admin # Access the 'admin' attribute on the User object
  end
end