# coding: utf-8
$LOAD_PATH.unshift File.expand_path('../lib', File.dirname(__FILE__))
require 'rubygems'
require 'sinatra'
require 'erb'
require 'person'

Person.data_dir = File.join(File.dirname(__FILE__), '..', 'data')

helpers do
  include Rack::Utils; alias_method :h, :escape_html
end

get '/' do
  erb :index
end

get '/register' do
	@person = Person.new({})
  @person.error_messages = [""]
	erb :register
end

post '/registered' do
    @person = Person.new(params)
    if @person.save()
        erb :registered
    else
        erb :register
    end
end

get '/search' do
	erb :search
end

post '/searched' do
	erb :searched
end
