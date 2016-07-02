class UsersController < ApplicationController
  before_action :set_user,       only: [:edit, :update, :show, :followings, :followers]
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]


  def show
    @microposts = @user.microposts.order(created_at: :desc)
  end

  def new
    @user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  	  log_in @user
  	  flash[:success] = "Welcome to the Sample App!"
  	  redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
  end
  
  def update
    if @user.update(user_params)
      # 保存に成功した場合はトップページへリダイレクト
      redirect_to @user , notice: 'プロフィールを編集しました'
    else
      # 保存に失敗した場合は編集画面へ戻す
      render 'edit'
    end
  end

  # フォローしているユーザーを取得
  def followings
    @users = @user.following_users
  end
  
  # フォローされているユーザーを取得
  def followers
    @users = @user.follower_users
  end

  private

  def user_params
  	params.require(:user).permit(:name, :email, :password, :password_confirmation, :prefectures_code, :profile)
  end
  
  def set_user
    @user = User.find(params[:id])
  end


  # ログイン済みユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください"
      redirect_to login_url
    end
  end

	# 正しいユーザーかどうか確認
	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_url) unless current_user?(@user)
	end

end