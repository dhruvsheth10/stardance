class Admin::Users::RolePolicy < ApplicationPolicy
  def create?
    user.admin? || user.super_admin?
  end

  def destroy?
    create?
  end
end
