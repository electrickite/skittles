class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAIL_FROM'] || 'admin@localhost'
  layout 'mailer'
end
