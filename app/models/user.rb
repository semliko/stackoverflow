# Class user
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise(
    :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable,
    :omniauthable,
    omniauth_providers: [:github]
  )
  has_many :questions
  has_many :answers
  has_many :awards, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :authorizations

  def author_of?(user_id)
    user_id == id
  end

  def self.find_for_oauth(auth)
    authorisation = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    authorisation.user if authorisation
  end
end
