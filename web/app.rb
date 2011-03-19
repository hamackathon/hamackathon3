# coding: utf-8
require 'rubygems'
require 'sinatra'
require 'erb'

helpers do
  include Rack::Utils; alias_method :h, :escape_html
end

get '/' do
  erb :index
end

get '/register' do
	erb :register
end

post '/register' do
	erb :registered
end

get '/search' do
	erb :search
end

post '/search' do
	erb :searched
end
