require 'sinatra'
require 'sass/plugin/rack'

use Sass::Plugin::Rack

get '/' do
  erb "When was the last time you fell in love with a sandwich?"
end
