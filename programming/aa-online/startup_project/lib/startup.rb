require "employee"

class Startup
  attr_reader :name, :funding, :salaries, :employees

  def initialize(name, funding, salaries)
    @name = name
    @funding = funding
    @salaries = salaries
    @employees = []
  end

  def valid_title?(title)
    @salaries.has_key?(title)
  end

  def >(startup)
    @funding > startup.funding
  end

  def hire(name, title)
    if valid_title?(title)
      @employees << Employee.new(name, title)
    else
      raise 'Not a valid title.'
    end
  end

  def size
    @employees.length
  end

  def pay_employee(employee)
    wage = @salaries[employee.title]
    if @funding > wage
      employee.pay(wage)
      @funding -= wage
    else
      raise 'Not enough funding.'
    end
  end

  def payday
    @employees.each { |e| self.pay_employee(e) }
  end

  def average_salary
    sum = 0
    @employees.each do |employee|
      sum += @salaries[employee.title]
    end
    sum / @employees.length.to_f
  end

  def close
    @employees = []
    @funding = 0
  end

  def acquire(other_startup)
    @funding += other_startup.funding
    @employees = [*@employees, *other_startup.employees]
    other_startup.salaries.each do |title, salary|
      @salaries[title] = salary if !@salaries.has_key?(title)
    end

    other_startup.close
  end


end

