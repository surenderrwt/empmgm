class Employee < ApplicationRecord
    validates :employee_id, :first_name, :last_name, :email, :doj, :salary, presence: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :phone_numbers, format: { with: /\A(\+\d{1,3}[- ]?)?\d{10}\z/ }, allow_blank: true
    validates_uniqueness_of :employee_id, case_sensitive: false
    validate :valid_doj

    def valid_doj
        errors.add(:doj, "should not be in future") if doj && doj > Date.today
    end
end
