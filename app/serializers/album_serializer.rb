class AlbumSerializer < ActiveModel::Serializer
  attributes :id, :name, :year, :artist_id, :artist, :user

  def artist
    artist_service = ArtistsService.new
    artist_service.get_by_id(object.artist_id)
  rescue
    nil
  end

  has_one :user
end
