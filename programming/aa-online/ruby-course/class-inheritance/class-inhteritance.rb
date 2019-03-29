class Employee
  attr_accessor :name, :title, :salary, :boss

  def initialize(name, title, salary, boss)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
  end

  def bonus(multiplier)
    @salary * multiplier
  end
    
end

class Manager < Employee

  def initialize(name, title, salary, boss)
    super(name, title, salary, boss)
    @employees = []
  end

  def bonus(multiplier)
    @employees.reduce(0) do |total, employee|
       intermediate = total + (employee.salary * multiplier)
       intermediate += employee.bonus(multiplier) if employee.is_a?(Manager)
       intermediate
    end
  end

  def add_employee(employee)
    @employees.push(employee)
  end
end

ned = Manager.new("ned", "founder", 1000000, nil)
darren = Manager.new("darren", "ta manager", 78000, ned)
shawna = Employee.new("shawna", "ta", 12000, darren)
david = Employee.new("david", "ta", 10000, darren)

ned.add_employee(darren)

darren.add_employee(shawna)
darren.add_employee(david)

p ned.bonus(5) # => 500_000
p darren.bonus(4) # => 88_000
p david.bonus(3) # => 30_000

