require_relative "questions_database"

class Reply
  attr_accessor :id, :question_id, :reply_id, :user_id, :body

  def initialize(options = {})
    @id, @question_id, @reply_id, @user_id, @body = options.values_at(
          'id', 'question_id', 'reply_id', 'user_id', 'body')
  end

  def self.find_by_id(id)
    reply_row = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = :id
    SQL

    raise "Reply doesn't exist" if reply_row.empty?

    Reply.new(reply_row.first)
  end
end
