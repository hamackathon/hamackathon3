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
	p "new"
	@person = Person.new({})
  @person.error_messages = [""]
	erb :register
end

post '/registered' do
	input = params
    input["gender"] = (params[:gender] == "male") ? "男性" : "女性" if !(params[:gender] == nil || params[:gender].empty?)
    @person = Person.new(input)
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
