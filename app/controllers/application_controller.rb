class ApplicationController < ActionController::Base
    include SessionsHelper
    before_action :login_required

    private

    # ログインしないとログイン画面（ログアウト状態の）以外のメニューにアクセスできないようにする
    def login_required
        redirect_to new_session_path, notice: t('common.notice_login') unless current_user 
    end

    # ログインした状態でログイン画面とアカウント登録画面にアクセスできないようにする
    def logout_required
        if current_user.present?
            redirect_to tasks_path, notice: t('common.notice_logout')
        end
    end

    # 管理者権限（=admin）を持っていない状態でユーザー一覧、ユーザー登録画面にアクセスできないようにする
    def admin_user
        unless current_user.admin?
            redirect_to tasks_path, notice: t('common.notice_admin_needs')
        end
    end
end
