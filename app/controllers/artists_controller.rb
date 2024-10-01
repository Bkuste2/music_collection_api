class ArtistsController < ApplicationController
  before_action :artist_service

  def index
    @artists = @artist_service.get_all
    if @artists.nil? || @artists.empty?
      render json: { message: "No artists found" }, status: :no_content
    else
      artists_with_albums = @artists.map do |artist|
        {
          **artist.as_json,
          albums: Album.where(artist_id: artist['id']).as_json
        }
      end

      render json: artists_with_albums
    end
  end

  def show
    @artist = @artist_service.get_by_id(artist_params[:id])
    if @artist.nil?
      render json: { error: "Artist not found" }, status: :not_found
    else
      artist_with_albums = @artist.as_json.merge(albums: Album.where(artist_id: @artist['id']).as_json)
      render json: artist_with_albums
    end
  end

  private

  def artist_params
    params.permit(:id)
  end

  def artist_service
    @artist_service = ArtistsService.new
  end
end
