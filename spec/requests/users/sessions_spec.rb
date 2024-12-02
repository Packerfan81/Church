require 'rails_helper'

RSpec.describe Users::SessionsController, type: :request do
  let!(:user) { create(:user, email: "user@example.com", password: "password") }
  let!(:admin) { create(:user, email: "admin@example.com", password: "password", admin: true) }

  describe "POST /users/sign_in" do
    it "logs in a regular user and redirects to root_path" do
      post user_session_path, params: { user: { email: user.email, password: "password" } }
      expect(response).to redirect_to(root_path)
    end

    it "logs in an admin user and redirects to admin_dashboard_path" do
      post user_session_path, params: { user: { email: admin.email, password: "password" } }
      expect(response).to redirect_to(admin_dashboard_path)
    end

    it "fails to log in with invalid credentials" do
      post user_session_path, params: { user: { email: user.email, password: "wrong_password" } }
      expect(response).to render_template(:new)
      expect(flash[:alert]).to eq("Invalid email or password.")
    end
  end
end