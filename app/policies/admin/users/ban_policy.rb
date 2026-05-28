class Admin::Users::BanPolicy < ApplicationPolicy
  def create?
    user.admin? || user.fraud_dept?
  end

  def destroy?
    create?
  end
end
