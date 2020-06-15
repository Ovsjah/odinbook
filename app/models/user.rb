class User < ApplicationRecord
  attr_writer :login
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable,
    :validatable, :omniauthable,
    omniauth_providers: PROVIDERS

  validates :username, presence: true, uniqueness: true, case_sensitive: false

  has_one_attached :avatar

  has_many :posts, -> { order(created_at: :desc) }, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  has_many :comments, dependent: :destroy
  has_many :commented_posts, -> { distinct }, through: :comments, source: :post

  has_and_belongs_to_many :friends,
    -> { order(created_at: :asc) },
    foreign_key: :pal_id,
    join_table: :relations,
    class_name: 'User'
  has_many :sent_friend_requests,
    foreign_key: :sender_id,
    class_name: "FriendRequest",
    dependent: :destroy
  has_many :received_friend_requests,
    foreign_key: :receiver_id,
    class_name: "FriendRequest",
    dependent: :destroy

  before_destroy { friends.clear }

  scope :case_insensitive_find, -> (attribute, value) { where("lower(#{attribute}) = ?", value.downcase).take }

  class << self
    def find_for_database_authentication(warden_conditions)
      if login = warden_conditions[:login]
        where(["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]).take
      elsif warden_conditions.has_key?(:username) || warden_conditions.has_key?(:email)
        where(warden_conditions).take
      end
    end

    def from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.username = auth.info.name
        user.generate_username until user.valid?
      end
    end
  end

  def login
    @login || username || email
  end

  def send_friend_request(receiver)
    return if receiver == self
    sent_friend_requests.create(receiver: receiver) unless sent_friend_requests.where(receiver: receiver).any?
  end

  def accept_friend_request(friend_request)
    return if friend_request.accepted?
    friend_request.toggle!(:accepted)
    @friend = friend_request.sender
    set_friendship unless @friend.friends.include? self
  end

  def unfriend(user_id)
    user = self.class.find(user_id)
    received_friend_requests.find_by_sender_id(user)&.destroy
    sent_friend_requests.find_by_receiver_id(user)&.destroy
    user.friends.delete(self)
    friends.delete(user)
  end

  def like(post_id)
    likes.create(post_id: post_id)
  end

  def dislike(post_id)
    likes.find_by_post_id(post_id).destroy
  end

  def comment(post_id, comment)
    comments.create(post_id: post_id, content: comment)
  end

  private

    def generate_username
      self.username += (self.username.first + rand.to_s[2..3])
    end

    def set_friendship
      friends << @friend
      @friend.friends << self
      @friend.received_friend_requests.pending.find_by_sender_id(self.id)&.destroy
    end
end
