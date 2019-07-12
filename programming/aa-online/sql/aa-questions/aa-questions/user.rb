require_relative "questions_database"
require_relative "question"
require_relative "reply"
require_relative "question_follow"
require_relative "question_like"
require_relative "model_base"

class User < ModelBase
  attr_accessor :id, :fname, :lname

  def self.find_by_name(fname, lname)
    data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT * FROM users WHERE fname = ? AND lname = ?
    SQL

    return nil if data.count == 0
    return User.new(data[0]) if data.count == 1
    data.map { |datum| User.new(datum) }
  end

  def initialize(options)
    @id = options["id"]
    @fname = options["fname"]
    @lname = options["lname"]
  end

  def authored_questions
    Question.find_by_author_id(self.id)
  end

  def authored_replies
    Reply.find_by_author_id(self.id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(self.id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(self.id)
  end

  def average_karma
    data = QuestionsDatabase.instance.execute(<<-SQL, self.id)
      SELECT 
        CAST(COUNT(question_likes.question_id) AS FLOAT) 
        / COUNT(DISTINCT questions.id) as average_karma
      FROM questions LEFT JOIN question_likes ON question_likes.question_id = questions.id
      WHERE questions.author_id = ?
    SQL
    data.first["average_karma"]
  end

end
