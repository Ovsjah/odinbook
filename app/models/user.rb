class User < ApplicationRecord
  PROVIDERS = %w[facebook google_oauth2 twitter]

  attr_writer :login
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable,
    :validatable, :omniauthable,
    omniauth_providers: PROVIDERS

  before_save { username.downcase! }

  validates :username, presence: true, uniqueness: true

  has_and_belongs_to_many :friends,
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
        user.username = format(auth.info.name)
        user.generate_username until user.valid?
      end
    end

    def format(name)
      name.downcase.gsub(/([[:punct:]]+|\s+)/) { |m| m.blank? ? '_' : '' }
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

  def generate_username
    self.username += (self.username.first + rand.to_s[2..3])
  end

  def unfriend(user_id)
    user = self.class.find(user_id)
    received_friend_requests.find_by_sender_id(user)&.destroy
    sent_friend_requests.find_by_receiver_id(user)&.destroy
    user.friends.delete(self)
    friends.delete(user)
  end

  private

    def set_friendship
      friends << @friend
      @friend.friends << self
    end
end
