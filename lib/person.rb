# conding: utf-8
require 'yaml'
require 'erb'
require 'digest/md5'
require 'fileutils'

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
    @path ||= File.join(Person.data_dir, self.id[0, 2], self.id[2, 2], "#{self.id}.yaml")
  end
  
  def save()
    dir = File.expand_path('..', self.path)
    FileUtils.mkdir_p(dir)
    File.open(self.path, 'w') do |f|
      f.puts self.to_yaml
    end
    return true
  end
  
  def delete()
    File.delete(self.path)
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