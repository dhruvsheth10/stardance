class Admin::Users::ImpersonationPolicy < ApplicationPolicy
  def create?
    return false unless user.admin? || user.super_admin?
    return false if user.id == record.id
    return false if record.admin? && !user.super_admin?

    true
  end

  def destroy?
    user.admin? || user.super_admin?
  end
end
