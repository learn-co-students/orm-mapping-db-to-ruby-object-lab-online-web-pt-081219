class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    sql = <<~SQL
      SELECT * FROM students
    SQL

    result = DB[:conn].execute(sql)

    result.map {|row| self.new_from_db(row)}

  end

  def self.all_students_in_grade_9
    self.all.select{|s| s.grade == "9"}
  end

  def self.students_below_12th_grade
    self.all.select{|s| s.grade.to_i < 12}
  end

  def self.first_X_students_in_grade_10(num)
    arr = self.all.select{|s| s.grade == "10"}
    new_arr = arr[0...num]
  end

  def self.first_student_in_grade_10
    self.all.find{|s| s.grade == "10"}
  end

  def self.all_students_in_grade_X(num)
    self.all.select{|s| s.grade.to_i == num}
  end

  def self.find_by_name(name)
    sql = <<~SQL
      SELECT * FROM students WHERE name = ? LIMIT 1
    SQL
    self.new_from_db(DB[:conn].execute(sql, name).flatten)

  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
