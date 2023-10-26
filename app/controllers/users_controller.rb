class UsersController < ApplicationController

    # 登録済みのuserデータを編集・更新、参照、削除する場合はアカウントに紐づくuserインスタンスの利用が必要であるため、各アクション実行前に定義
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    # ログインが必要ないアクションを定義
    skip_before_action :login_required, only:[:new,:create]
    # ログアウトの必要があるアクションを定義
    before_action :logout_required, only:[:new,:create]

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            log_in(@user)
            redirect_to tasks_path, notice:t('notice.successful_user',action: "登録")
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
            redirect_to user_path, notice:t('notice.successful_user',action: "更新")
        else
            render :edit
        end
    end

    def destroy
        @user.destroy
        redirect_to tasks_path
    end

    private

    # アカウントが登録済みの場合、アカウントに紐づくuserインスタンスを抽出
    def set_user
        @user = User.find(params[:id])
    end

    #ストロングパラメーターの設定
    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

end
