ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.default :charset => "utf-8"
ActionMailer::Base.smtp_settings = {
  address: "smtp.gmail.com",
  port: 587,
  authentication: "plain",
  enable_starttls_auto: true,
  user_name: ENV["GMAIL_USERNAME"],
  password: ENV["GMAIL_PASSWORD"]
}