class Admin::Users::BalanceAdjustmentsController < Admin::ApplicationController
  def create
    authorize [:admin, :users, :balance_adjustment]

    @user = User.find(params[:user_id])

    if cannot_adjust_balance_for?(@user)
      flash[:alert] = "You cannot adjust the balance of another #{protected_role_name(@user)}."
      return redirect_to admin_user_path(@user)
    end

    amount = params[:amount].to_i
    reason = params[:reason].presence

    if fraud_dept_stardust_limit_exceeded?(amount)
      flash[:alert] = "Fraud department members can only grant up to 1 Stardust without the grant_stardust permission."
      return redirect_to admin_user_path(@user)
    end

    if amount.zero?
      flash[:alert] = "Amount cannot be zero."
      return redirect_to admin_user_path(@user)
    end

    if reason.blank?
      flash[:alert] = "Reason is required."
      return redirect_to admin_user_path(@user)
    end

    @user.ledger_entries.create!(
      amount: amount,
      reason: reason,
      created_by: "#{current_user.display_name} (#{current_user.id})",
      ledgerable: @user
    )

    flash[:notice] = "Balance adjusted by #{amount} for #{@user.display_name}."
    redirect_to admin_user_path(@user)
  end

  private

  def cannot_adjust_balance_for?(target_user)
    return false if current_user.has_role?(:super_admin) || current_user.has_role?(:admin)
    return true if target_user == current_user

    if current_user.has_role?(:fraud_dept)
      return true if target_user.has_role?(:admin) || target_user.has_role?(:super_admin)
    end

    protected_roles = [ :admin, :super_admin, :fraud_dept ]
    shared_protected_roles = current_user.roles & protected_roles & target_user.roles
    shared_protected_roles.any?
  end

  def fraud_dept_stardust_limit_exceeded?(amount)
    return false unless current_user.has_role?(:fraud_dept)
    return false if current_user.has_role?(:admin) || current_user.has_role?(:super_admin)
    return false if Flipper.enabled?(:grant_stardust, current_user)

    amount > 1
  end

  def protected_role_name(target_user)
    if target_user.has_role?(:super_admin) || target_user.has_role?(:admin)
      "admin"
    elsif target_user.has_role?(:fraud_dept)
      "fraud department member"
    else
      "user"
    end
  end
end
