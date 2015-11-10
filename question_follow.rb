require_relative "questions_database"

class QuestionFollow
  attr_accessor :id, :question_id, :user_id

  def initialize(options = {})
    @id, @question_id, @user_id = options.values_at('id', 'question_id', 'user_id')
  end

  def self.find_by_id(id)
    question_follow_row = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = :id
    SQL

    raise "Question followers don't exist" if question_follow_row.empty?

    QuestionFollow.new(question_follow_row.first)
  end
end
