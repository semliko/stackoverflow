# Class user
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise(
    :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable
  )
  has_many :questions
  has_many :answers
  has_many :awards, dependent: :destroy
  has_many :votes, dependent: :destroy

  def author_of?(user_id)
    user_id == id
  end
end
