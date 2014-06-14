require 'sinatra'
require 'sass/plugin/rack'

require 'set'

require './lib/sandwiches'

use Sass::Plugin::Rack

set :sandwiches, Sandwiches.new

get '/' do
  erb :categories
end

get '/sandwich/:name' do
  @sandwich = settings.sandwiches.set.find {|s| s.slug.eql?(params[:name]) }
  erb :sandwich
end

get '/create' do
  @sandwich = Sandwiches.generate
  erb :sandwich
end

get '/random' do
  @sandwich = settings.sandwiches.random
  erb :sandwich
end

