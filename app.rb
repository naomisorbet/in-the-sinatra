require 'sinatra'
require 'instagram_api'

# Go to http://instagram.com/developer to get your client ID and client secret.
CLIENT_ID = "YOUR CLIENT ID"
CLIENT_SECRET = "YOUR CLIENT SECRET"

# Set the redirect uri for your application to the following:
REDIRECT_URI = "http://localhost:4567/callback"

client = Instagram.client(
  :client_id => CLIENT_ID,
  :client_secret => CLIENT_SECRET,
  :callback_url => REDIRECT_URI
)

get '/' do
  output = '<h2>Popular Media</h2>'
  client.popular_media.data.each do |p|
    output << "<a href='#{p.link}'><img src='#{p.images.thumbnail.url}'></a>&nbsp;"
  end
  output << '<br /><h3><a href="/auth">Click here</a> to authenticate with Instagram.</h3>'
  output
end

get '/auth' do
  redirect client.authorize_url
end

get '/callback' do
  client.get_access_token(params[:code])
  redirect '/dashboard'
end

get '/dashboard' do
  user = client.user
  output = "<h2>#{user.data.username}'s feed</h2>"
  client.feed.data.each do |f|
    output << "<a href='#{f.link}'><img src='#{f.images.low_resolution.url}'></a><br />
    <img src='#{f.user.profile_picture}' width='20'>&nbsp;#{f.user.username}<br /><br />"
  end
  output
end