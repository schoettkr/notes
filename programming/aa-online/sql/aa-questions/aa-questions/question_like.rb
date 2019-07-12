require_relative "questions_database"
require_relative "question"
require_relative "user"
require_relative "model_base"

class QuestionLike
  attr_accessor :id, :user_id, :question_id

  def self.likers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT users.id, fname, lname FROM question_likes
      JOIN users ON user_id = users.id
      WHERE question_id = ?
    SQL

    return nil if data.count == 0
    return User.new(data[0]) if data.count == 1
    data.map { |datum| User.new(datum) }
  end

  def self.num_likes_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT COUNT(user_id) AS num_likes FROM question_likes
      WHERE question_id = ?
    SQL

    return 0 if data.count == 0
    data.first["num_likes"]
  end

  def self.liked_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT questions.id, title, body, author_id FROM question_likes
      JOIN questions ON questions.id = question_id
      WHERE user_id = ?
    SQL

    return nil if data.count == 0
    return Question.new(data[0]) if data.count == 1
    data.map { |datum| Question.new(datum) }
  end

  def self.most_liked_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT questions.id, title, body, author_id, COUNT(user_id) as likes FROM question_likes
      JOIN questions ON questions.id = question_id
      GROUP BY questions.id
      ORDER BY likes DESC
      LIMIT ?
    SQL

    return nil if data.count == 0
    return Question.new(data[0]) if data.count == 1
    data.map { |datum| Question.new(datum) }
  end

  def initialize(options)
    @id = options["id"]
    @user_id = options["user_id"]
    @question_id = options["question_id"]
  end

end
