require 'sinatra'
require 'sass/plugin/rack'

require 'set'

require './lib/sandwiches'

use Sass::Plugin::Rack

get '/' do
  erb :categories
end

get '/sandwich/:name' do
  @sandwich = Sandwich.new("Reuben", Set.new([
    :corned_beef,
    :sauerkraut,
    :russian_dressing,
    :rye_bread
  ]))
  erb :sandwich
end

get '/category/:name' do
  @sandwich = Sandwich.new("Reuben", Set.new([
    :corned_beef,
    :sauerkraut,
    :russian_dressing,
    :rye_bread
  ]))
  erb :sandwich
end
