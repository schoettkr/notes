require 'active_support/inflector'
require_relative "questions_database"

class ModelBase

  def self.table
    self.to_s.tableize
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT * FROM #{table} WHERE id = ?
    SQL

    return nil if data.count == 0
    self.new(data.first)
  end

  def self.all
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT * FROM #{table}
    SQL

    return nil if data.count == 0
    data.map { |datum| self.new(datum) }
  end

  def save
    @id ? update : create
  end

  def create
    raise 'already saved to db' unless id.nil?
    attr = all_attributes
    attr.delete("id")
    values = attr.values
    columns = attr.keys.join(", ")
    question_marks = (["?"] * values.count).join(", ")
    QuestionsDatabase.instance.execute(<<-SQL, *values)
      INSERT INTO #{self.class.table} (#{columns}) VALUES (#{question_marks})
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    raise 'not saved to db yet' if id.nil?
    attr = all_attributes
    attr.delete("id")
    values = attr.values
    set_statement = attr.keys.map { |col| "#{col} = ?" }.join(", ")
    QuestionsDatabase.instance.execute(<<-SQL, *values, id)
      UPDATE #{self.class.table}
      SET  #{set_statement}
      WHERE id = ?
    SQL
  end

  def all_attributes
    attributes = {}
    self.instance_variables.each { |key| attributes[key[1..-1]] = get_val(key) }
    attributes
  end

  def get_val(key)
    instance_variable_get(key)
  end

  def self.where(options)
    if options.is_a?(Hash)
      keys, vals = options.keys, options.values
      where_clause = keys.map { |k| "#{k} = ?"}.join(" AND ")
    else
      where_clause = options
      vals = []
    end

    data = QuestionsDatabase.instance.execute(<<-SQL, *vals)
      SELECT *
      FROM #{self.table}
      WHERE #{where_clause}
    SQL

    data.map { |datum| self.new(datum) }
  end

end
