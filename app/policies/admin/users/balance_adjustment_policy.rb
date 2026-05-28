class Admin::Users::BalanceAdjustmentPolicy < ApplicationPolicy
  def create?
    user.admin? || user.fraud_dept?
  end
end
