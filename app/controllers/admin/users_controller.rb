class Admin::UsersController < ApplicationController
     # 登録済みのuserデータを編集・更新、参照、削除する場合はアカウントに紐づくuserインスタンスの利用が必要であるため、各アクション実行前に定義
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :admin_user

    def index
        @user = current_user
        @users = User.all.page(params[:page])
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            redirect_to admin_users_path, notice:t('notice.successful_admin_user',action: "登録")
        else
            render :new
        end
    end

    def show
    end

    def edit
    end

    def update
        if @user.update(user_params)
            redirect_to admin_users_path, notice:t('notice.successful_admin_user',action: "更新")
        else
            render :edit
        end
    end

    def destroy
        if @user.destroy
            redirect_to admin_users_path, notice:t('notice.successful_admin_user',action: "削除")
        else
            @users = User.all.page(params[:page])
            render :index
        end
    end

    private

    # アカウントが登録済みの場合、アカウントに紐づくuserインスタンスを抽出
    def set_user
        @user = User.find(params[:id])
    end
    

    #ストロングパラメーターの設定
    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
    end

end
