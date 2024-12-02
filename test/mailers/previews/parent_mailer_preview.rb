# Preview all emails at http://localhost:3000/rails/mailers/parent_mailer
class ParentMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/parent_mailer/child_confirmation_email
  def child_confirmation_email
    ParentMailer.child_confirmation_email
  end
end
