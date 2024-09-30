class User < ApplicationRecord
  has_many :albums

  accepts_nested_attributes_for :albums

  enum role: { user: 'user', admin: 'admin' }

  validates :full_name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :role, inclusion: { in: roles.keys }
  validate :username_must_be_alphanumeric

  private

  def username_must_be_alphanumeric
    unless username =~ /\A[a-zA-Z0-9]+\z/
      errors.add(:username, "deve conter apenas letras e números")
    end
  end
end
