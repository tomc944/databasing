require_relative "questions_database"

class Question
  attr_accessor :id, :title, :body, :author

  def initialize(options = {})
    @id, @title, @body, @author = options.values_at('id', 'title', 'body', 'author')
  end

  def self.find_by_id(id)
    question_row = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = :id
    SQL

    raise "Question doesn't exist" if question_row.empty?

    Question.new(question_row.first)
  end

  def self.find_by_title(title)
    question_row = QuestionsDatabase.instance.execute(<<-SQL, title: title)
      SELECT
        *
      FROM
        questions
      WHERE
        title = :title
    SQL

    raise "Question doesn't exist" if question_row.empty?

    question_row.map { |row| Question.new(row) }
  end
end
