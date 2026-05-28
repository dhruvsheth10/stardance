class Admin::Users::YswsOverridePolicy < ApplicationPolicy
  def update?
    user.admin? || user.fraud_dept?
  end
end
