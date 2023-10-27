class User < ApplicationRecord
    # 以下を実装するため、has_secure_passwordメソッドを追加
    # ・ハッシュ化されたパスワードをDB内のpassword_digestカラムに保存
    # ・仮想カラムとしてpasswordとpassword_confirmationを利用
    # ・passwordとpassword_confirmationの値が入力されているかと二つの値が一致するかのバリデーションを追加
    # ・authenticateメソッドが使えるようになる
    has_secure_password

    # バリデーションを実行する前にemailに含まれる大文字を小文字に変換する
    before_validation { email.downcase! }

    # バリデーションの設定
    validates :email, uniqueness: true
    validates :email, presence: true
    validates :name, presence: true
    validates :password, length: { minimum: 6 }


    # 管理者が一人しかいない状態でそのユーザを削除しようとした場合に削除できないよう制御
    before_destroy do
        if User.where(admin: true).count == 1 && self.admin == true
            self.errors.add(:base, '管理者が0人になるため権限を削除できません')
            throw :abort
        end
    end

    # 管理者が一人しかいない状態でそのユーザから管理者権限を外す更新をしようとした場合に更新できないよう制御
    before_update do
        if User.where(admin: true).count == 1 && self.will_save_change_to_attribute?("admin",from: true, to: false)
            self.errors.add(:base, '管理者が0人になるため権限を変更できません') 
            throw :abort
        end
    end

    # tasksテーブルとのアソシエーション
    has_many :tasks, dependent: :destroy



end
