require "test_helper"

class ParentMailerTest < ActionMailer::TestCase
  test "child_confirmation_email" do
    mail = ParentMailer.child_confirmation_email
    assert_equal "Child confirmation email", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
