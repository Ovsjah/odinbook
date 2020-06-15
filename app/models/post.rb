class Post < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: :user_id

  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user

  has_many :comments, dependent: :destroy
  has_many :commenting_users, -> { distinct }, through: :comments, source: :user

  has_many_attached :images

  scope :recent_posts_of, -> (friends_and_user) do
    where("user_id in (?) and created_at >= ?", friends_and_user, 1.week.ago.utc).order(created_at: :desc)
  end
end
