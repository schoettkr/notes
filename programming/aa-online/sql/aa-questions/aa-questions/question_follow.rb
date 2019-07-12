require_relative "questions_database"
require_relative "user"
require_relative "question"
require_relative "model_base"

class QuestionFollow < ModelBase
  attr_accessor :id, :user_id, :question_id

  def self.followers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT users.id, fname, lname
      FROM question_follows
      JOIN users ON users.id = user_id
      WHERE question_follows.question_id = ?
    SQL

    return nil if data.count == 0
    return User.new(data[0]) if data.count == 1
    data.map { |datum| User.new(datum) }
  end

  def self.followed_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT questions.id, title, body, questions.author_id
      FROM question_follows
      JOIN questions ON questions.id = question_id
      WHERE question_follows.user_id = ?
    SQL

    return nil if data.count == 0
    return Question.new(data[0]) if data.count == 1
    data.map { |datum| Question.new(datum) }
  end

  def self.most_followed_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT questions.id, title, body, questions.author_id, COUNT(user_id) as followers
      FROM question_follows
      JOIN questions ON questions.id = question_id
      GROUP BY questions.id
      ORDER BY followers DESC
      LIMIT ?
    SQL

    return nil if data.count == 0
    data.map { |datum| Question.new(datum) }
  end

  def initialize(options)
    @id = options["id"]
    @user_id = options["user_id"]
    @question_id = options["question_id"]
  end

end
