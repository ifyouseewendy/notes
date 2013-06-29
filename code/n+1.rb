# encoding: utf-8

# ======================================================
# <N+1 problem>
#
# Post.all.each do |p|
#   puts p.category.name
# end
#
# select * from POSTS;
#
# select * from CATEGORYS where POST_ID=1;
# select * from CATEGORYS where POST_ID=2;
# select * from CATEGORYS where POST_ID=3;
# select * from CATEGORYS where POST_ID=4;
#
# --- solution ---
#
# Post.all.includes(:category).each do |p|
#   puts p.category.name
# end
#
# select * from POSTS;
#
# select CATEGORY.* from CATEGORY
#   where CATEGORY.POST_ID IN (1,2,3,4)
#
# ======================================================

require 'rubygems'
require 'faker'
require 'active_record'
require 'benchmark'

# This call creates a connection to our database.

ActiveRecord::Base.establish_connection(
  :adapter  => "mysql",
  :host     => "127.0.0.1",
  :username => "wendi", # Note that while this is the default setting for MySQL,
  :password => "wendi",     # a properly secured system will have a different MySQL
                            # username and password, and if so, you'll need to
                            # change these settings.
  :database => "test")

# First, set up our database...
class Category <  ActiveRecord::Base
end

unless Category.table_exists?
  ActiveRecord::Schema.define do
    create_table :categories do |t|
        t.column :name, :string
    end
  end
end

Category.create(:name=>'Sara Campbell\'s Stuff')
Category.create(:name=>'Jake Moran\'s Possessions')
Category.create(:name=>'Josh\'s Items')
number_of_categories = Category.count

class Item <  ActiveRecord::Base
  belongs_to :category
end

# If the table doesn't exist, we'll create it.

unless Item.table_exists?
  ActiveRecord::Schema.define do
    create_table :items do |t|
        t.column :name, :string
        t.column :category_id, :integer
    end
  end
end

puts "Loading data..."

item_count = Item.count
item_table_size = 10000

if item_count < item_table_size
  (item_table_size - item_count).times do
    Item.create!(:name=>Faker.name,
                 :category_id=>(1+rand(number_of_categories.to_i)))
  end
end

puts "Running tests..."

Benchmark.bm do |x|
  [100,1000,10000].each do |size|
    x.report "size:#{size}, with n+1 problem" do
      @items=Item.all.limit(size)
      @items.each do |i|
        i.category
      end
    end
    x.report "size:#{size}, with :include" do
      @items=Item.all.includes(:category).limit(size)
      @items.each do |i|
        i.category
      end
    end
  end
end
