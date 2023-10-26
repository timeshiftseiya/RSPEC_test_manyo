FactoryBot.define do
  # テストデータとして一般ユーザーのデータを作成
  factory :user do
    name { "test_user1" }
    email { "test_user@gmail.com" }
    password_digest { "test_user" }
    admin { false }
  end
end
