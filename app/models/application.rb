class Application < ApplicationRecord
  has_secure_token :acess_token
  has_many :chats, dependent: :destroy
  validates :name, presence: true

  def self.cached_app(token)
    Rails.cache.fetch(token, expires_in: 1.hour){
      Application.find_by(acess_token: token)
    }
  end
end
