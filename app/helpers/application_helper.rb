module ApplicationHelper
  def to_bootstrap_flash(message_type)
    message_type.to_s == 'warning' ? 'warning' : (message_type.to_s == 'notice') ? 'success' : 'danger'
  end
end
