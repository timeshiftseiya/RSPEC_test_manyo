require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do

  describe '登録機能' do
    before do
      @task = FactoryBot.create(:task)
    end
  
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_task_path
        fill_in"タイトル", with:@task.title
        fill_in"内容",with:@task.content
        fill_in"終了期限",with:@task.deadline_on
        select @task.priority , from:'優先度'
        select @task.status, from:'ステータス'
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
    before do
      @task = FactoryBot.create(:task)
    end

    context '任意のタスク詳細画面に遷移した場合' do
      it 'そのタスクの内容が表示される' do
        visit task_path(@task)
        expect(page).to have_content @task.title
        expect(page).to have_content @task.content
       end
     end
  end

  describe 'ソート機能' do
    let!(:first_task) { FactoryBot.create(:task, title: 'first_task', created_at: '2025-02-18', status: 0, priority: 1, deadline_on: '2025-02-18') }
    let!(:second_task) { FactoryBot.create(:task, title: 'second_task', created_at: '2025-02-17', status: 1, priority: 2, deadline_on: '2025-02-17') }
    let!(:third_task) { FactoryBot.create(:task, title: 'third_task', created_at: '2025-02-16', status: 2, priority: 0, deadline_on: '2025-02-16') }

    before do
      visit tasks_path
    end
    
    context '「終了期限」というリンクをクリックした場合' do
      it "終了期限昇順に並び替えられたタスク一覧が表示される" do
        # allメソッドを使って複数のテストデータの並び順を確認する
        click_link('終了期限')
        task_list = all('tbody tr')
        expect(task_list[0]).to have_text("third_task")
        expect(task_list[1]).to have_text("second_task")
        expect(task_list[2]).to have_text("first_task")
      rescue Selenium::WebDriver::Error::StaleElementReferenceError
        sleep 1
        retry
      end
    end

    context '「優先度」というリンクをクリックした場合' do
      it "優先度の高い順に並び替えられたタスク一覧が表示される" do
        # allメソッドを使って複数のテストデータの並び順を確認する
        click_link('優先度')
        task_list = all('tbody tr')
        expect(task_list[0]).to have_text("second_task")
        expect(task_list[1]).to have_text("first_task")
        expect(task_list[2]).to have_text("third_task")
      rescue Selenium::WebDriver::Error::StaleElementReferenceError
        sleep 1
        retry
      end
    end
  end

  describe '検索機能' do
    let!(:first_task) { FactoryBot.create(:task, title: 'first_task', created_at: '2025-02-18', status: 0, priority: 1, deadline_on: '2025-02-18') }
    let!(:second_task) { FactoryBot.create(:task, title: 'second_task', created_at: '2025-02-17', status: 1, priority: 2, deadline_on: '2025-02-17') }
    let!(:third_task) { FactoryBot.create(:task, title: 'third_task', created_at: '2025-02-16', status: 2, priority: 0, deadline_on: '2025-02-16') }

    before do
      visit tasks_path
    end


    context 'タイトルであいまい検索をした場合' do
      it "検索ワードを含むタスクのみ表示される" do
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        fill_in 'search[title]', with: 'first'
        click_button"検索"
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content'first_task'
        expect(task_list[0]).to have_no_content'second_task'
        expect(task_list[0]).to have_no_content'third_task'
      end
    end

    context 'ステータスで検索した場合' do
      it "検索したステータスに一致するタスクのみ表示される" do
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        select '未着手', from: 'search[status]'
        click_button"検索"
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content("未着手")
        expect(task_list[0]).not_to have_content("着手中")
        expect(task_list[0]).not_to have_content("完了")
      end
    end

    context 'タイトルとステータスで検索した場合' do
      it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
        select '未着手', from: 'search[status]'
        fill_in 'search[title]', with: 'first'
        click_button"検索"
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content("未着手").and have_content'first_task'
        expect(task_list[0]).to have_no_content("着手中").and have_no_content'second_task'
        expect(task_list[0]).to have_no_content("完了").and have_no_content'third_task'
      end
    end
  end

end