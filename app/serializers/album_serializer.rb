class AlbumSerializer < ActiveModel::Serializer
  attributes :id, :name, :year, :artist_id, :user
  has_one :user
end
