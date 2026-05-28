class Admin::Users::HackatimeSyncPolicy < ApplicationPolicy
  def create?
    user.admin? || user.fraud_dept?
  end
end
