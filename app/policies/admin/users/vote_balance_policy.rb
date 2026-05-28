class Admin::Users::VoteBalancePolicy < ApplicationPolicy
  def update?
    user.admin? || user.fraud_dept?
  end
end
