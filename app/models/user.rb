class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :boards, dependent: :destroy   # ADICIONADO

 def self.from_omniauth(auth)
   Rails.logger.debug 'sdhjdsakjhkdhsjakjhdsakjhsadkhjsda'
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name if user.respond_to?(:name)
      user.token = auth.credentials.token
      user.refresh_token = auth.credentials.refresh_token
      user.token_expires_at = Time.at(auth.credentials.expires_at)
    end
  end
end
