module ApplicationHelper

  def google_usercart(user)
    %Q{
        <h4> #{user.try(:full_name)||v.try(:name)}</h4>
        <div class='small'>phone: #{ user.try(:phone)}</div>
        <div class='small'>email: #{ user.try(:email)}</div>
        <div class='small'>address: #{ user.try(:address)}</div>
     }
  end

  def with_blank_tmpl(str)
    str.blank? ? "---" : str
  end

  def error_messages!(resource)
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.name)

    html = <<-HTML
    <div class="error">
      <h2>#{sentence}</h2>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end


end
