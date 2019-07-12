require_relative "questions_database"
require_relative "user"
require_relative "question"
require_relative "model_base"

class Reply < ModelBase
  attr_accessor :id, :parent_reply_id, :author_id, :question_id, :body

  def self.find_by_author_id(author_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT * FROM replies WHERE author_id = ?
    SQL

    return nil if data.count == 0
    return Reply.new(data[0]) if data.count == 1
    data.map { |datum| Reply.new(datum) }
  end

  def self.find_by_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT * FROM replies WHERE question_id = ?
    SQL

    return nil if data.count == 0
    return Reply.new(data[0]) if data.count == 1
    data.map { |datum| Reply.new(datum) }
  end

  def initialize(options)
    @id = options["id"]
    @parent_reply_id = options["parent_reply_id"]
    @author_id = options["author_id"]
    @question_id = options["question_id"]
    @body = options["body"]
  end

  def author
    User.find_by_id(self.author_id)
  end

  def question
    Question.find_by_id(self.question_id)
  end

  def parent_reply
    Reply.find_by_id(self.parent_reply_id)
  end

  def child_replies
    data = QuestionsDatabase.instance.execute(<<-SQL, self.id)
      SELECT * FROM replies WHERE parent_reply_id = ?
    SQL

    return nil if data.count == 0
    return Reply.new(data[0]) if data.count == 1
    data.map { |datum| Reply.new(datum) }
  end

end
