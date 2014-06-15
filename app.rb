require 'sinatra'
require 'sass/plugin/rack'

require 'set'

require './lib/sandwiches'

use Sass::Plugin::Rack

set :sandwiches, Sandwiches.new
set :demo, [
  settings.sandwiches[0], 
  settings.sandwiches[2],
  settings.sandwiches[30]
]
set :created, [
  Sandwich.new("cajun turkey on hoagie", {
    protein: ["cajun turkey"],
    cheese: ["edam"],
    bread: "hoagie",
    sauce: ["soy sauce"],
    veggies: ["carrot"]
  }),
  Sandwich.new("roast pork on roll", {
    protein: ["roast pork"],
    cheese: ["colby jack"],
    bread: "roll",
    sauce: ["spicy marinara", "marshmallow cream"],
    veggies: ["eggplant", "green bean"]
  }),
  Sandwich.new("jagdwurst and bierwurst on wonderbread", {
    protein: ["jagdwurst","bierwurst"],
    cheese: ["goat cheese"],
    bread: "wonderbread",
    sauce: ["southwest sauce"],
    veggies: ["bell pepper", "wristwatch", "chickpea"]
  })
]

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

get '/demo' do
  @sandwich = settings.sandwiches[0]
  erb :demo
end

get '/demo/create' do
  @sandwich = settings.created.shift || Sandwiches.generate
  erb :sandwich_demo
end

get '/demo/:slug' do
  @sandwich = settings.demo.shift || settings.sandwiches.random
  erb :sandwich_demo
end

