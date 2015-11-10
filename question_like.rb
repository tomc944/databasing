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
end
