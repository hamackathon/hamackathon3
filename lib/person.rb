# conding: utf-8
require 'yaml'

class Person
  MALE = "m"
  FEMALE = "f"
  attr_accessor :name, :address, :tel, :birthday, :gender, :logs
  
  def initialize(params={})
    self.name = params['name']
    self.address = params['address']
    self.tel = params['tel']
    self.birthday = params['birthday']
    self.gender = params['gender']
  end
  
  def self.load(file_path)
    params = YAML.load(File.read(file_path))
    Person.new(params)
  end
end