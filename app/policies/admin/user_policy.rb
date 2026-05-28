class Admin::UserPolicy < ApplicationPolicy
  def index?
    user.admin? || user.fraud_dept? || user.helper?
  end

  def show?
    index?
  end

  def update?
    user.admin? || user.fraud_dept?
  end
end
