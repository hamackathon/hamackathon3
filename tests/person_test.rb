# conding: utf-8
require File.expand_path('test_helper', File.dirname(__FILE__))
require 'person'

class PersonTest < Test::Unit::TestCase
  TARO = {
    'name' => "山田太郎",
    'address' => "東京都千代田区1丁目1番地",
    'tel' => "03-1234-5678",
    'birthday' => "1970-01-01",
    'gender' => Person::MALE
  }
  
  def setup
    Person.data_dir = File.join(File.dirname(__FILE__), 'out')
  end
  
  def test_initialize
    person = Person.new(TARO)
    assert_not_nil(person)
    assert_equal(TARO['name'], person.name)
    assert_equal(TARO['address'], person.address)
    assert_equal(TARO['tel'], person.tel)
    assert_equal(TARO['birthday'], person.birthday)
    assert_equal(TARO['gender'], person.gender)
  end
  
  def test_load
    taro_file = File.join(File.dirname(__FILE__), 'fixtures', 'taro.yaml')
    person = Person.load(taro_file)
    assert_not_nil(person)
    assert_equal("山田太郎", person.name)
  end
  
  def test_data_dir
    assert_not_nil(Person.data_dir)
  end
  
  def test_to_yaml
    taro = Person.new(TARO)
    yaml = taro.to_yaml
    taro_copy = YAML.load(yaml)
    assert_equal("山田太郎", taro_copy['name'])
  end
  
  def test_id
    taro_id = Person.new(TARO).id
    assert_not_nil(taro_id)
    another_taro_id = Person.new(TARO).id
    assert_equal(taro_id, another_taro_id)
  end
  
  def test_path
    taro = Person.new(TARO)
    assert_not_nil(taro.path)
  end
  
  def test_save
    taro = Person.new(TARO)
    assert !File.exist?(taro.path)
    assert(taro.save())
    assert File.exist?(taro.path)
    File.delete(taro.path)
  end
  
  def test_delete
    taro = Person.new(TARO)
    taro.save()
    assert File.exist?(taro.path)
    taro.delete()
    assert !File.exist?(taro.path)
  end
end