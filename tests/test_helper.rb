$LOAD_PATH.unshift '../lib'
require 'test/unit'
require 'person'

Person.data_dir = File.join(File.dirname(__FILE__), 'out')
