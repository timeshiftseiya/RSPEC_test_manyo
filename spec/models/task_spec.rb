require 'rails_helper'

RSpec.describe 'タスクモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title: '', content: '企画書を作成する。')
        expect(task).not_to be_valid
      end
    end

    context 'タスクの説明が空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title: '企画書作成', content: '')
        expect(task).not_to be_valid
      end
    end

    context 'タスクのタイトルと説明に値が入っている場合' do
      it 'タスクを登録できる' do
        task = Task.create(title: '企画書作成', content: '企画書を作成する。', deadline_on: '2025-02-18', status: 0, priority: 1)
        expect(task).to be_valid
      end
    end
  end

  describe '検索機能' do
    # テストデータを複数作成する
    let!(:first_task) { FactoryBot.create(:task, title: 'first_task_title', status: 0, priority: 1, deadline_on: '2025-02-18') }
    let!(:second_task) { FactoryBot.create(:task, title: 'second_task_title', status: 1, priority: 2, deadline_on: '2025-02-17') }
    let!(:third_task) { FactoryBot.create(:task, title: 'third_task_title', status: 2, priority: 0, deadline_on: '2025-02-16') }

    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it "検索ワードを含むタスクが絞り込まれる" do
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
        expect(Task.search_title('first')).to include(first_task)
        expect(Task.search_title('first')).not_to include(second_task)
        expect(Task.search_title('first')).not_to include(third_task)
        expect(Task.search_title('first').count).to eq 1
      end
    end

    context 'scopeメソッドでステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
        expect(Task.search_status(0)).to include(first_task)
        expect(Task.search_status(0)).not_to include(second_task)
        expect(Task.search_status(0)).not_to include(third_task)
        expect(Task.search_status(0).count).to eq 1
      end
    end

    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      it "検索ワードをタイトルに含み、かつステータスに完全一致するタスクが絞り込まれる" do
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
        expect(Task.search_title_status(first_task)).to include(first_task)
        expect(Task.search_title_status(first_task)).not_to include(second_task)
        expect(Task.search_title_status(first_task)).not_to include(third_task)
        expect(Task.search_title_status(first_task).count).to eq 1
      end
    end
  end
end