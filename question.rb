require_relative "questions_database"

class Question
  attr_accessor :id, :title, :body, :author_id

  def initialize(options = {})
    @id, @title, @body, @author_id = options.values_at(
            'id', 'title', 'body', 'author_id')
  end

  def self.find_by_id(id)
    question_row = QuestionsDatabase.instance.get_first_row(<<-SQL, id: id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = :id
    SQL

    raise "Question doesn't exist" if question_row.empty?

    Question.new(question_row)
  end

  def self.find_by_title(title)
    question_rows = QuestionsDatabase.instance.execute(<<-SQL, title: title)
      SELECT
        *
      FROM
        questions
      WHERE
        title = :title
    SQL

    raise "Question doesn't exist" if question_rows.empty?

    question_rows.map { |row| Question.new(row) }
  end

  def self.find_by_author_id(author_id)
    author_rows = QuestionsDatabase.instance.execute(<<-SQL, author_id: author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = :author_id
    SQL

    raise "Author doesn't exist" if author_rows.empty?

    author_rows.map { |row| Question.new(row) }
  end

  def author
    User.find_by_id(@author_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

end
