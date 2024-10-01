require 'httparty'

class ArtistsService
  include HTTParty
  base_uri 'https://europe-west1-madesimplegroup-151616.cloudfunctions.net'
  default_timeout 15

  def initialize
    @headers = {
      "Content-Type" => "application/json",
      "Authorization" => "Basic ZGV2ZWxvcGVyOlpHVjJaV3h2Y0dWeQ=="
    }
  end

  def get_all
    response = self.class.get("/artists-api-controller", headers: @headers)
    artists = handle_response(response)
    artists["json"].flatten if artists["json"]
  end

  def get_by_id(id)
    response = self.class.get("/artists-api-controller?artist_id=#{id}", headers: @headers)
    artist = handle_response(response)
    artist["json"]&.first
  end

  private

  def handle_response(response)
    case response.code
    when 200
      JSON.parse(response.body) unless response.body.nil? || response.body.empty?
    when 204
      nil
    when 404
      raise "Error: Resource not found (404)"
    when 500...600
      raise "Error: Server error (#{response.code})"
    else
      raise "Error: Unexpected response (#{response.code})"
    end
  rescue Net::ReadTimeout
    raise "Error: Request timeout"
  end
end
