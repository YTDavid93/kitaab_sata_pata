require "test_helper"

class UsersMailerTest < ActionMailer::TestCase
  test "confirmation" do
    user = users(:unconfirmed_user)
    mail = UsersMailer.confirmation(user)
    assert_equal "Please confirm your email", mail.subject
    assert_equal [ user.email ], mail.to
    assert_match user.name, mail.body.encoded
  end
end
