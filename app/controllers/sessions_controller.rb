class SessionsController < ApplicationController
	def new
	end

	def create
		@user = User.find_by(email: params[:session][:email].downcase)
		if @user && @user.authenticate(params[:session][:password])
			log_in @user
			redirect_back_or @user
		else
			flash.now[:danger] = 'E-mail/パスワードを確認し再度入力してください。'
			render 'new'
		end
	end
	

	def destroy
		session[:user_id] = nil
		redirect_to root_path
	end
end