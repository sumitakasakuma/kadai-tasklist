class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show]
  before_action :correct_user, only: [:show]
  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @tasks = @user.tasks.order('created_at DESC').page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success]='ユーザーを登録しました。'
      redirect_to root_url
    else
      flash.now[:danger]='ユーザーの登録に失敗しました。'
      render :new
  end
end

  private
  
  def logged_in_user
      unless logged_in?
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to root_url unless @user == current_user
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end