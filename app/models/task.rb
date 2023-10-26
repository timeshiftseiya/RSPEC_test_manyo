class Task < ApplicationRecord
    validates :title, presence: true
    validates :content, presence: true
    validates :deadline_on, presence: true
    validates :priority, presence: true
    validates :status, presence: true
    enum status: { 未着手: 0, 着手中: 1, 完了: 2}
    enum priority: { 低: 0, 中: 1, 高: 2}

    scope :old_created, -> {order(created_at: :desc)}
    scope :near_deadline, -> {order(deadline_on: :asc)}
    scope :high_priority, -> {order(priority: :desc,created_at: :desc)}
    scope :search_status, ->(status){ where(status: status) }
    scope :search_title,  ->(title){ where('title LIKE(?)',"%#{title}%") }
    scope :search_title_status, ->(search) do
        search_title(search[:title])
            .search_status(search[:status])
    end

    # usrsテーブルとのアソシエーション
    belongs_to :user
end
