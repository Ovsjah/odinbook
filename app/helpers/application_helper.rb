module ApplicationHelper
  def to_bootstrap_flash(message_type)
    message_type.to_s == 'warning' ? 'warning' : (message_type.to_s == 'notice') ? 'success' : 'danger'
  end

  def avatar_for(user, size, rounded = 'rounded-circle')
    if user.avatar.attached?
      image_tag user.avatar.variant(resize_to_fill: [size, size]), class: "img-fluid #{rounded}"
    else
      image_tag 'avatar-placeholder.gif', size: size, class: "img-fluid #{rounded}"
    end
  end
end
