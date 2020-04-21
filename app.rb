require 'sinatra'
require 'geocoder'
require 'rest-client'

helpers do
  def lat_long(city)
    response = Geocoder.search(city)
    response.first.coordinates
  end

  def weather(city)
    lat, long = lat_long(city)
    api_key = request.env['HTTP_X_API_KEY']
    RestClient.get(
      "https://api.darksky.net/forecast/#{api_key}/#{lat},#{long}"
    )
  end
end

get '/' do
  @city = params['city'] || 'San Francisco'
  @weather = JSON.parse(weather(@city))
  erb :index, locals: { city: @city, weather: @weather }
end
