require 'active_record'
require 'sapine'

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

ActiveRecord::Migration.create_table :test_models do |t|
  t.string :state
  t.timestamps
end

class TestModel < ActiveRecord::Base
end