# conding: utf-8
require 'rubygems'
require 'yaml'
require 'erb'
require 'digest/md5'
require 'fileutils'
require 'grit'

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
  
  def self.init_repo
    Grit::Repo.init(Person.data_dir)
  end
  
  def self.rm_repo
    FileUtils.rmtree(File.join(Person.data_dir, '.git'))
  end
  
  def self.find_by_keyword(keyword)
    # @@repo ||= Grit::Repo.new(Person.data_dir)
    results = []
    Dir.chdir(Person.data_dir) {
      out = `git grep "#{keyword}"`
      lines = out.split("\n")
      lines.each do |line|
        path = line.split(':').first
        fullpath = File.join(Person.data_dir, path)
        person = Person.load(fullpath)
        results << person
      end
    }
    return results
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
  
  def add_to_repo
    @repo ||= Grit::Repo.new(Person.data_dir)
    blob = Grit::Blob.create(
      @repo,
      :name => self.path,
      :data => self.fullpath
    )
    Dir.chdir(Person.data_dir) { @repo.add(blob.name) }
  end
  
  def commit(message=nil)
    @repo ||= Grit::Repo.new(Person.data_dir)
    Dir.chdir(Person.data_dir) { @repo.commit_all(message) }
  end
  
  def save_and_commit(message=nil)
    unless self.save
      return nil
    self.add_to_repo
    self.commit(message)
  end
  
  def rm_from_repo
    @repo ||= Grit::Repo.new(Person.data_dir)
    Dir.chdir(Person.data_dir) { @repo.remove(self.path) }
  end
  
  def rm_and_commit(message=nil)
    self.rm_from_repo
    self.commit(message)
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