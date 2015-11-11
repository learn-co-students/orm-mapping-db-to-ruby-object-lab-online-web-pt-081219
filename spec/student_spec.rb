require_relative 'spec_helper'

describe Student do

  before do
    Student.create_table
  end

  after do
    Student.drop_table
  end

  let(:pat) {Student.new}
  let(:attributes) {
    {
      :id => 1,
      :name => 'Pat',
      :grade => 12
    }
  }

  describe 'attributes' do 
    it 'has an id, name, grade' do
      pat.id = attributes[:id]
      pat.name = attributes[:name]
      pat.grade = attributes[:grade]

      expect(pat.id).to eq(attributes[:id])
      expect(pat.name).to eq(attributes[:name])
      expect(pat.grade).to eq(attributes[:grade])
    end
  end

  describe '.create_table' do
    it 'creates a student table' do
      Student.drop_table
      Student.create_table

      table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='students';"
      expect(DB[:conn].execute(table_check_sql)[0]).to eq(['students'])
    end
  end

  describe '.drop_table' do
    it "drops the student table" do
      Student.create_table
      Student.drop_table

      table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='students';"
      expect(DB[:conn].execute(table_check_sql)[0]).to be_nil
    end
  end

  describe "#save" do 
    it 'saves an instance of the Student class to the database' do 
      pat.save
      expect(DB[:conn].execute("SELECT * FROM students")).to eq([[1, nil, nil]])
    end
  end
end