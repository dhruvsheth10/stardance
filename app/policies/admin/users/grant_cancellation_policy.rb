class Admin::Users::GrantCancellationPolicy < ApplicationPolicy
  def create?
    user.admin? || user.fraud_dept?
  end
end
