class Admin::Users::FeatureFlagPolicy < ApplicationPolicy
  def create?
    user.admin?
  end

  def destroy?
    create?
  end
end
