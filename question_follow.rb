require_relative "questions_database"

class QuestionFollow
  attr_accessor :id, :question_id, :user_id

  def initialize(options = {})
    @id, @question_id, @user_id = options.values_at('id', 'question_id', 'user_id')
  end

  def self.find_by_id(id)
    question_follow_row = QuestionsDatabase.instance.get_first_row(<<-SQL, id: id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = :id
    SQL

    raise "Question followers don't exist" if question_follow_row.empty?

    QuestionFollow.new(question_follow_row)
  end

  def self.followers_for_question_id(question_id)
    followers_row = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
      SELECT
        *
      FROM
        users
      JOIN
        question_follows
      ON
        question_follows.user_id = users.id
      JOIN
        questions
      ON
        questions.id = question_follows.question_id
      WHERE
        questions.id = :question_id
    SQL

    raise "There are no people following that question" if followers_row.empty?

    followers_row.map { |row| User.new(row) }
  end

  def self.followed_questions_for_user_id(user_id)
    followers_questions_row = QuestionsDatabase.instance.execute(<<-SQL, user_id: user_id)
      SELECT
        *
      FROM
        questions
      JOIN
        question_follows
      ON
        question_follows.question_id = questions.id
      JOIN
        users
      ON
        users.id = question_follows.user_id
      WHERE
        users.id = :user_id
    SQL

    raise "There are no people following that question" if followers_questions_row.empty?

    followers_questions_row.map { |row| Question.new(row) }
  end
end
