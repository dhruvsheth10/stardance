class Admin::Users::VerificationPolicy < ApplicationPolicy
  def create?
    user.admin? || user.fraud_dept?
  end
end
