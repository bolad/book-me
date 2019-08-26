class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :omniauthable

  validates :fullname, presence: true, length: {maximum: 50}

  has_many :rooms

  def self.from_omniauth(auth)

    user = User.where(email: auth.info.email).first

    if user
      return user
    else
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.fullname = auth.info.name   # assuming the user model has a name
        user.image = auth.info.image # assuming the user model has an image
        user.uid = auth.provider

        # If you are using confirmable and the provider(s) you use validate emails,
        # uncomment the line below to skip the confirmation emails.
        user.uid = auth.uid
        user.skip_confirmation!
      end
    end

  end
end
