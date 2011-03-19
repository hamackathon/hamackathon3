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
end