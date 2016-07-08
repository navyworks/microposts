class FavoritesController < ApplicationController
  before_action :logged_in_user, only: [:create]

  def show
    @user = User.find(params[:id])
    @favorites = @user.favorites.order(created_at: :desc)
  end


  def create
    @micropost = Micropost.find(params[:favorite][:micropost_id])
    current_user.like(@micropost)
    flash[:success] = "お気に入りに追加しました！"
    redirect_to root_url
  end

  def destroy
    @micropost = Micropost.find(params[:favorite][:micropost_id])
    current_user.unlike(@micropost)
    flash[:success] = "お気に入りを削除しました！"
    redirect_to root_url
  end

  # private
  # def favorite_params
  #   params.require(:favorite).permit(:user_id, :micropost_id)
  # end
end
