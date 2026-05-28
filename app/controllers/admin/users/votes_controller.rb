class Admin::Users::VotesController < Admin::ApplicationController
  def index
    authorize [:admin, :users, :vote]

    @user = User.find(params[:user_id])

    @pagy, @votes = pagy(
      @user.votes.includes(:project).order(created_at: :desc)
    )
  end
end
