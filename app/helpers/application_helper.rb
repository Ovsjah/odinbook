module ApplicationHelper
  def to_bootstrap_flash(message_type)
    message_type.to_s == 'warning' ? 'warning' : (message_type.to_s == 'notice') ? 'success' : 'danger'
  end

  def avatar_for(user, size, class_names = 'img-fluid rounded-circle')
    if user.avatar.attached?
      image_tag user.avatar.variant(resize_to_fill: [size, nil]), size: "#{size}x#{size}", class: class_names
    else
      image_tag 'avatar-placeholder.gif', size: "#{size}x#{size}", class: class_names
    end
  end
end
