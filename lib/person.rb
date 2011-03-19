# conding: utf-8
require 'rubygems'
require 'yaml'
require 'erb'
require 'digest/md5'
require 'fileutils'

class Person
  MALE = "m"
  FEMALE = "f"
  
  attr_accessor :name, :address, :tel, :birthday, :gender, :logs, :error_messages
  
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
    
  def self.data_dir=(path)
    @@data_dir = path
  end
  
  def self.data_dir
    @@data_dir
  end
    
  def to_yaml
    person = self
    erb = ERB.new(TEMPLATE)
    erb.result(binding)
  end
  
  def id
    @id ||= Digest::MD5.hexdigest("#{self.name}+#{self.tel}")
  end
  
  def path
    [self.id[0, 2], self.id[2, 2], "#{self.id}.yaml"].join(File::SEPARATOR)
  end
  
  def fullpath
    @fullpath ||= File.join(Person.data_dir, self.path)
  end
  
  def save()
    unless self.name && self.name.strip != ''
      self.error_messages = ["Name is required."]
      return false
    end
    
    dir = File.expand_path('..', self.fullpath)
    FileUtils.mkdir_p(dir)
    File.open(self.fullpath, 'w') do |f|
      f.puts self.to_yaml
    end
    
    return true
  end
  
  def delete()
    File.delete(self.fullpath)
  end
  
  TEMPLATE =<<EOS
name: "<%= person.name %>"
address: "<%= person.address %>"
tel: "<%= person.tel %>"
birthday: "<%= person.birthday %>"
gender: "<%= person.gender %>"
logs:
EOS
end