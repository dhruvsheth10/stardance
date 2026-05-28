class Admin::Users::OrderRejectionPolicy < ApplicationPolicy
  def create?
    user.admin? || user.fraud_dept?
  end
end
