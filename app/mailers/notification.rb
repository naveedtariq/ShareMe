class Notification < ActionMailer::Base
  def change_code(user, emails)
    @user = user
    mail(:to => emails,
         :from => Devise.mailer_sender,
         :subject => I18n.t("mailers.notification.subject.change_code", :user_name => user.name))
  end
end
