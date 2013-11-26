module Korma
  class Entity
    attr_reader :tablename
    attr_reader :columns

    def initialize(tablename, *columns)
      @tablename = tablename
      @columns = columns
    end

    def to_s
      @tablename.to_s
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

  def parse_column_options(column_options)
    raise ArgumentError unless column_options.is_a? Array

    if column_options.count == 1
      column_options = column_options[0]
    end

    # TODO: Make this lazy. Use yield.
    columns, values = [], []
    column_options.each do |key, value|
      columns << key
      values << "\"#{value}\""
    end

    [columns.join(', '), values.join(', ')]
  end

  def insert(entity, *columns)
    binds = []

    column_sql, values_sql = parse_column_options(columns)
    sql = "INSERT INTO #{entity} (#{column_sql}) VALUES (#{values_sql})"

    [sql, binds]
  end

  def update(entity, columns, *predicates)
    binds = []

    column_sql = column_sql(columns, binds)
    where = predicates.any? ? ' WHERE ' : ''

    predicate_sql = ''
    predicates.each do |pred|
      predicate_sql += column_sql(pred, binds)
    end

    sql = "UPDATE #{entity} SET #{column_sql}#{where}#{predicate_sql}"

    [sql, binds]
  end
end


include Korma

users = Entity.new(:users, { first: 'VARCHAR2(50)' }, { last: 'VARCHAR2(50)' })

p users
p select(users)
p insert(users, { first: 'Hello', last: 'World' })
p update(users, { first: 'Justin', last: 'Valentini'})
p update(users, { first: 'Justin', last: 'Valentini'}, { id: 1 })
