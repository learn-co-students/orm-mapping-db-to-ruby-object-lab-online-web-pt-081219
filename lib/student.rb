class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
     
  new_student = self.new  # self.new is the same as running Student.new
  new_student.id = row[0]
  new_student.name =  row[1]
  new_student.grade = row[2]
  new_student  # return the newly created instance
end
  

  def self.all
   sql = <<-SQL
      SELECT *
      FROM students
    SQL
 
    DB[:conn].execute(sql)
  end

  def self.find_by_name(name)
   sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL
 
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  
  
  def self.all_students_in_grade_9(grade)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 9
    SQL
  DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
      
  
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
