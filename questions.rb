require 'sqlite3'
require 'singleton'
require 'byebug'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.results_as_hash = true
    self.type_translation = true
  end
end

class User
  attr_accessor :id, :fname, :lname

  def initialize(options = {})
    @id, @fname, @lname = options.values_at('id', 'fname', 'lname')
  end

  def self.find_by_id(id)
    user_row = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        users
      WHERE
        id = :id
    SQL

    raise "User doesn't exist" if user_row.empty?

    User.new(user_row.first)
  end

  def self.find_by_name(fname, lname)
    user_row = QuestionsDatabase.instance.execute(<<-SQL, fname: fname, lname: lname)
      SELECT
        *
      FROM
        users
      WHERE
        lname = :lname AND fname = :fname
    SQL

    raise "User doesn't exist" if user_row.empty?

    user_row.map { |row| User.new(row) }
  end
end

class Question
  attr_accessor :id, :title, :body, :user_id

  def initialize(options = {})
    @id, @title, @body, @user_id = options.values_at('id', 'title', 'body', 'user_id')
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

class QuestionLike
  attr_accessor :id, :question_id, :user_id

  def initialize(options = {})
    @id, @question_id, @user_id = options.values_at('id', 'question_id', 'user_id')
  end

  def self.find_by_id(id)
    question_like_row = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = :id
    SQL

    raise "Question likes don't exist" if question_like_row.empty?

    QuestionLike.new(question_like_row.first)
  end
end


  # def self.get_all
  #   data = QuestionsDatabase.instance.execute(<<-SQL)
  #     SELECT
  #       *
  #     FROM
  #       users
  #   SQL
  #
  #   data.map { |datum| User.new(datum) }
  # end
