require_relative "questions_database"

class User
  attr_accessor :id, :fname, :lname

  def initialize(options = {})
    @id, @fname, @lname = options.values_at('id', 'fname', 'lname')
  end

  def self.find_by_id(id)
    user_row = QuestionsDatabase.instance.get_first_row(<<-SQL, id: id)
      SELECT
        *
      FROM
        users
      WHERE
        id = :id
    SQL

    raise "User doesn't exist" if user_row.empty?

    User.new(user_row)
  end

  def self.find_by_name(fname, lname)
    user_rows = QuestionsDatabase.instance.execute(<<-SQL, fname: fname, lname: lname)
      SELECT
        *
      FROM
        users
      WHERE
        lname = :lname AND fname = :fname
    SQL

    raise "User doesn't exist" if user_rows.empty?

    user_rows.map { |row| User.new(row) }
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

  def average_karma
    avg_karma = QuestionsDatabase.instance.get_first_value(<<-SQL, id: @id)
      SELECT
        (COUNT(question_likes.id) / CAST(SUM(DISTINCT(questions.author_id)) AS FLOAT)) karma
      FROM
        questions
      JOIN
        users ON users.id = questions.author_id
      LEFT OUTER JOIN
        question_likes ON question_likes.question_id = questions.id
      WHERE
        questions.author_id = :id
    SQL

    avg_karma
  end

  def save
    raise "Already in the Database, man..." if id

    QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      INSERT INTO
        users (fname, lname)
      VALUES
        (?, ?)
    SQL

    @id = QuestionsDatabase.instance.last_insert_row_id
  end

end
