module SessionsHelper
    # ログイン中のユーザーの情報を取得する
    # 初回ログインの場合　→　ログイン時に作成されたsessionを引数としてUser.find～でuser情報を@current_userに格納
    # 2回目以降のログインの場合　→　@current_userにはすでに情報があるので、current_userメソッドの実行にてcurrent_userインスタンスの取得
    def current_user
        @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    # ログインしているかどうかを判断する（Trueかfalseを返す）
    def logged_in?
        current_user.present?
    end

    # アカウント登録と同時にログインできるようにuserインスタンスを引数としてsessionを作成する
    def log_in(user)
        session[:user_id] = user.id
    end

    # （本人しかユーザー詳細画面にアクセスできないようにするため）ログインユーザーとユーザー詳細画面を閲覧しに来たユーザーが一致するかを判断する（Trueかfalseを返す）
    def correct_user?(user)
        user == current_user.id
    end

end