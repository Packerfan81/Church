class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@yourdomain.com'
  layout 'parent' # Optional, for custom email layouts
end