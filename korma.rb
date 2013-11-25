module Korma
  class Entity
    attr_reader :tablename, :columns

    def initialize(tablename, *columns)
      @tablename = tablename
      @columns = columns
    end
  end

  def select(entity, *columns)
    columns = ["#{entity.tablename}.*"]
    "SELECT #{columns.join(', ')} FROM #{entity.tablename}"
  end

  def update(entity, columns, *predicates)
    binds = []

    column_sql = []
    columns.each do |key, value|
      column_sql << "#{key} = ?"
      binds << value
    end
    column_sql = column_sql.join(', ')

    where = predicates.any? ? ' WHERE ' : ''

    predicate_sql = []
    predicates.each do |key, value|
      predicate_sql << "#{key} = ?"
      binds << value
    end
    predicate_sql = predicate_sql.join(', ')

    ["UPDATE #{entity.tablename} SET #{column_sql}#{where}#{predicate_sql}", binds]
  end
end


include Korma

users = Entity.new(:users, { first: 'VARCHAR2(50)' }, { last: 'VARCHAR2(50)' })

p users
p select(users)
p update(users, { first: 'Justin', last: 'Valentini'})
p update(users, { first: 'Justin', last: 'Valentini'}, { id: 1 })
