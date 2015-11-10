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
