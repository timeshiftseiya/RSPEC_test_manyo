class SessionsController < ApplicationController
    # ログインが必要ないアクションを定義
    skip_before_action :login_required, only:[:new,:create]
    # ログアウトの必要があるアクションを定義
    before_action :logout_required, only:[:new,:create]

    def new
    end

    def create
        # ログイン画面に入力されたメールアドレスがusersテーブルにあるか検索し、検索した結果をuser変数に格納
        user = User.find_by(email: params[:session][:email].downcase)
        # authenticateメソッドを使って、メールアドレスとパスワードの組み合わせがusersテーブルのデータと一致するか検証
        if user&.authenticate(params[:session][:password])
        # 一致した場合、sessionメソッドを使い、sessionオブジェクトを作成した上、タスク一覧に遷移
            log_in(user)
            redirect_to tasks_path, notice: t('.success')
        else
            flash[:notice] = t('.fail')
            redirect_to new_session_path
        end
    end

    def destroy
        # セッションを削除する
        session.delete(:user_id)
        flash[:notice] = t('.logout')
        redirect_to new_session_path
    end

end
