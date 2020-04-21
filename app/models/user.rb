class User < ApplicationRecord
  PROVIDERS = %w[facebook google_oauth2 twitter]

  attr_writer :login
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: PROVIDERS

  before_save { username.capitalize! }

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
      end
    end
  end

  def login
    @login || username || email
  end
end
