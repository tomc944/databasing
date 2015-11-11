require_relative "questions_database"

class QuestionLike
  attr_accessor :id, :question_id, :user_id

  def initialize(options = {})
    @id, @question_id, @user_id = options.values_at('id', 'question_id', 'user_id')
  end

  def self.find_by_id(id)
    question_like_row = QuestionsDatabase.instance.get_first_row(<<-SQL, id: id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = :id
    SQL

    raise "Question likes don't exist" if question_like_row.empty?

    QuestionLike.new(question_like_row)
  end

  def self.likers_for_question_id(question_id)
    question_likers_rows = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
      SELECT
        users.*
      FROM
        users
      JOIN
        question_likes ON question_likes.user_id = users.id
      JOIN
        questions ON question_likes.question_id = questions.id
      WHERE
        questions.id = :question_id
    SQL

    raise "Nobody likes that question" if question_likers_rows.empty?

    question_likers_rows.map { |row| User.new(row) }
  end

  def self.num_likes_for_question_id(question_id)
    num_question_likes = QuestionsDatabase.instance.get_first_value(<<-SQL, question_id: question_id)
      SELECT
        COUNT(users.id)
      FROM
        users
      JOIN
        question_likes ON question_likes.user_id = users.id
      JOIN
        questions ON question_likes.question_id = questions.id
      WHERE
        questions.id = :question_id
    SQL

    num_question_likes
  end

  def self.liked_questions_for_user_id(user_id)
    liked_questions_row = QuestionsDatabase.instance.execute(<<-SQL, user_id: user_id)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_likes ON question_likes.question_id = questions.id
      JOIN
        users ON users.id = question_likes.user_id
      WHERE
        user_id = :user_id
    SQL

    raise "Yo bro like some stuff" if liked_questions_row.empty?

    liked_questions_row.map { |row| Question.new(row) }
  end

  def self.most_liked_questions(n)
    most_liked_questions_rows = QuestionsDatabase.instance.execute(<<-SQL, n: n)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_likes
      ON
        question_likes.question_id = questions.id
      JOIN
        users
      ON
        users.id = question_likes.user_id
      GROUP BY
        question_likes.question_id
      ORDER BY
        COUNT(question_likes.user_id) DESC
      LIMIT
        :n
    SQL

    raise "There are no likers" if most_liked_questions_rows.empty?

    most_liked_questions_rows.map { |row| Question.new(row) }
  end
end
