module Korma
  class Entity
    attr_reader :tablename

    def initialize(tablename, *columns)
      @tablename = tablename
      @columns = columns
    end
  end

  def select(entity, *columns)
    columns = ["#{entity.tablename}.*"]
    "SELECT #{columns.join(', ')} FROM #{entity.tablename}"
  end
end


include Korma

users = Entity.new(:users)

p users
p select(users)
