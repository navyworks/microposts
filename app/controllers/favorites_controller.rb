class FavoritesController < ApplicationController
  before_action :logged_in_user, only: [:create]
  before_action :set_micropost, only: [:create]
  before_action :check_micropost, only: [:create]

  def show
    @user = User.find(params[:id])
    @favorite_microposts = @user.favorite_microposts
    # @favorites = @user.favorites #.order(created_at: :desc)
  end


  def create
    current_user.like(@micropost)
    flash[:success] = "お気に入りに追加しました！"
    redirect_to root_url
  end

  def destroy
    # @micropost = Micropost.find(params[:favorite][:micropost_id])
    # current_user.unlike(@micropost)
    @favorite = Favorite.find(params[:id])
    @favorite.destroy if @favorite.present?
    flash[:success] = "お気に入りを削除しました！"
    redirect_to root_url
  end
  
  def set_micropost
    @micropost = Micropost.find(params[:micropost_id])
  end
  
  def check_micropost
    redirect_to root_url if @micropost.user_id == current_user.id
  end

  # private
  # def favorite_params
  #   params.require(:favorite).permit(:user_id, :micropost_id)
  # end
end
