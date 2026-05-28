class Admin::Users::VotePolicy < ApplicationPolicy
  def index?
    user.admin? || user.fraud_dept?
  end
end
