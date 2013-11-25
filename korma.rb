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

  def column_sql(columns, binds)
    column_sql = []
    columns.each do |key, value|
      column_sql << "#{key} = ?"
      binds << value
    end
    column_sql.join(', ')
  end

  def update(entity, columns, *predicates)
    binds = []

    column_sql = column_sql(columns, binds)
    where = predicates.any? ? ' WHERE ' : ''
    predicate_sql = ''
    predicates.each do |pred|
      predicate_sql += column_sql(pred, binds)
    end

    sql = "UPDATE #{entity.tablename} SET #{column_sql}#{where}#{predicate_sql}"

    [sql, binds]
  end
end


include Korma

users = Entity.new(:users, { first: 'VARCHAR2(50)' }, { last: 'VARCHAR2(50)' })

p users
p select(users)
p update(users, { first: 'Justin', last: 'Valentini'})
p update(users, { first: 'Justin', last: 'Valentini'}, { id: 1 })
