class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: :user_id
  belongs_to :post

  scope :recent_comments, -> { order(created_at: :desc) }
end
