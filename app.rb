require 'sinatra'
require "sinatra/json"
require 'sinatra/activerecord'

class MyApp < Sinatra::Application
  enable :sessions
  configure do
   db = URI.parse(ENV['DATABASE_URL'] || 'postgres:///mr')

   ActiveRecord::Base.establish_connection(
     :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
     :host     => db.host,
#     :username => db.user,
#     :password => db.password,
     :database => db.path[1..-1],
     :encoding => 'utf8'
   )
  end
end

require_relative 'models/init'
require_relative 'routes/init'

get '/' do
  json message: "Welcome To Meeting Room App"
end

