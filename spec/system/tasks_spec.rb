require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  before do
    @task = FactoryBot.create(:task)
  end

  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_task_path
        fill_in"タイトル", with:@task.title
        fill_in"内容",with:@task.content
        click_button"登録する"
        expect(page).to have_content'タスクを登録しました'
      end
    end
  end

  describe '一覧表示機能' do
    let!(:first_task) { FactoryBot.create(:task, title: 'first_task', created_at: '2025-02-18') }
    let!(:second_task) { FactoryBot.create(:task, title: 'second_task', created_at: '2025-02-17') }
    let!(:third_task) { FactoryBot.create(:task, title: 'third_task', created_at: '2025-02-16') }
    let(:add_later) { FactoryBot.create(:task, title: 'add_task', created_at: '2025-02-19') }

    before do
      visit tasks_path
    end

    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        visit tasks_path
        task_list = all('tbody tr')
        # binding.pry
        expect(task_list[0]).to have_text("first_task")
        expect(task_list[1]).to have_text("second_task")
        expect(task_list[2]).to have_text("third_task")
      end
    end

    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        add_task = add_later.title
        visit tasks_path
        task_list = all('tbody tr')
        expect(task_list[0]).to  have_text("add_task")
      end
    end
  end

  describe '詳細表示機能' do
     context '任意のタスク詳細画面に遷移した場合' do
       it 'そのタスクの内容が表示される' do
        visit task_path(@task)
        expect(page).to have_content @task.title
        expect(page).to have_content @task.content
       end
     end
  end
end