ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'w'))

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'example.db'
)

ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.tables.include? 'users'
    create_table :users do |table|
      table.column :name, :string
      table.column :age,  :integer
      table.column :email, :string
      table.column :phone, :string
      table.column :time,  :string
    end
  end

  unless ActiveRecord::Base.connection.tables.include? 'messages'
    create_table :messages do |table|
      table.column  :user_id,  :integer
      table.column  :question, :string
      table.column  :answer,   :string
    end
  end
end

class User < ActiveRecord::Base
  has_many :messages
end

class Message < ActiveRecord::Base
  belongs_to :user
end
