class EmployeesController < ApplicationController
  before_action :set_employee, only: %i[ show update destroy ]

  # GET /employees
  def index
    @employees = Employee.all
    render json: @employees
  end

  # GET /employees/1
  def show
    puts salary = @employee.salary.to_i
    puts total_months = (Date.today.year - @employee.doj.to_date.year) * 12 + Date.today.month - @employee.doj.to_date.month + 1
    puts total_salary = salary * total_months
    tax_amount = calculate_tax(total_salary)
    cess_amount = total_salary > 2500000 ? (total_salary - 2500000) * 0.02 : 0

    render json: {
      employee_code: @employee.employee_id,
      first_name: @employee.first_name,
      last_name: @employee.last_name,
      yearly_salary: total_salary,
      tax_amount: tax_amount,
      cess_amount: cess_amount
    }
  end

  # POST /employees
  def create
    @employee = Employee.new(employee_params)

    if @employee.save
      render json: @employee, status: :created, location: @employee
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /employees/1
  def update
    if @employee.update(employee_params)
      render json: @employee
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  # DELETE /employees/1
  def destroy
    @employee.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    
    # def calculate_tax(salary)
    #   case salary
    #   when 0..250000
    #     0
    #   when 250001..500000
    #     (salary - 250000) * 0.05
    #   when 500001..1000000
    #     12500 + (salary - 500000) * 0.10
    #   else
    #     62500 + (salary - 1000000) * 0.20
    #   end
    # end

    def calculate_tax(salary)
      if salary <= 250000
        0
      elsif salary <= 500000
        (salary - 250000) * 0.05
      elsif salary <= 1000000
        12500 + (salary - 500000) * 0.1
      else
        12500 + 50000 + (salary - 1000000) * 0.2
      end
    end

    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def employee_params
      params.require(:employee).permit(:employee_id, :first_name, :last_name, :email, :phone_numbers, :doj, :salary)
    end
end
