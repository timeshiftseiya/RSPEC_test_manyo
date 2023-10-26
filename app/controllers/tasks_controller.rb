class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]
  before_action :correct_user, only:[:show, :edit]


  # GET /tasks or /tasks.json
  def index
    # 作成日の降順で全件表示
    @tasks = Task.where(user: current_user).old_created.page(params[:page])

    # 終了期限でのソートが実行された場合、終了期限の昇順で全件表示
    if params[:sort_deadline_on]
      @tasks = Task.where(user: current_user).near_deadline.page(params[:page])
    # 優先度でのソートが実行された場合、優先度の降順で全件表示
    elsif params[:sort_priority]
      @tasks = Task.where(user: current_user).high_priority.page(params[:page])     
    end

    # 「検索」が実行された場合の表示
    if params[:search].present?
      # 検索パラメータにタイトルとステータスの両方があった場合
      if params[:search][:title].present?&&params[:search][:status].present?
        @tasks = Task.where(user: current_user).search_title_status(params[:search]).page(params[:page])
      # 検索パラメータにタイトルのみがあった場合
      elsif params[:search][:title].present?
        @tasks = Task.where(user: current_user).search_title(params[:search][:title]).page(params[:page])
      # 検索パラメータにステータスのみがあった場合
      elsif params[:search][:status].present?
        @tasks = Task.where(user: current_user).search_status(params[:search][:status]).page(params[:page])
      # 検索パラメータに値がない場合
      else
        @tasks = Task.where(user: current_user).old_created.page(params[:page])
      end
    end
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = current_user.tasks.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = current_user.tasks.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_url, notice:t('notice.successful_task',action: "登録") }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice:t('notice.successful_task',action: "更新") }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice:t('notice.successful_task',action: "削除") }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
    end

    def correct_user
      task = Task.find(params[:id])
      @user = task.user_id
      redirect_to tasks_path, notice: t('notice.correct_user') unless correct_user?(@user)
    end

 end
