class UserSerializer < ActiveModel::Serializer
  attributes :id, :role, :full_name, :username, :password, :created_at, :updated_at
end
