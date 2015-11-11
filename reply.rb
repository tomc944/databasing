require_relative "questions_database"
require 'byebug'

class Reply
  attr_accessor :id, :question_id, :reply_id, :user_id, :body

  def self.get_all
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        replies
    SQL

    data.map { |datum| Reply.new(datum) }
  end

  def initialize(options = {})
    @id, @question_id, @reply_id, @user_id, @body = options.values_at(
          'id', 'question_id', 'reply_id', 'user_id', 'body')
  end

  def self.find_by_id(id)
    reply_row = QuestionsDatabase.instance.get_first_row(<<-SQL, id: id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = :id
    SQL

    raise "Reply doesn't exist" if reply_row.empty?

    Reply.new(reply_row)
  end

  def self.find_by_user_id(user_id)
    reply_rows = QuestionsDatabase.instance.execute(<<-SQL, user_id: user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = :user_id
    SQL

    raise "Reply doesn't exist" if reply_rows.empty?

    reply_rows.map { |row| Reply.new(row) }
  end

  def self.find_by_question_id(question_id)
    reply_rows = QuestionsDatabase.instance.execute(<<-SQL, question_id: question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = :question_id
    SQL

    raise "Reply doesn't exist" if reply_rows.empty?

    reply_rows.map { |row| Reply.new(row) }
  end

  def author
    User.find_by_id(@user_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    raise "This is a parent reply" if @reply_id.nil?
    Reply.find_by_id(@reply_id)
  end

  def child_replies
    all_replies = Reply.get_all

    all_children = []
    all_replies.each do |row|
      if row.reply_id == self.id
        all_children << row
      end
    end

    all_children
  end
end
