class ContactMailer < ApplicationMailer
  default from: "muckbo@muckbo.com" # 기본 발신자
  def contact_mail(mail_params)
    @user_mail = mail_params[:email]
    @subject = "먹보로 부터 도착한 contact 메일"
    @message = mail_params[:message]
    # 각각 메일 내용에 들어가야 할 부분들을 인스턴스 변수로 만들어줌
    mail(from: "muckbo@muckbo.com", to: @user_mail, subject: @subject)
  end
end
