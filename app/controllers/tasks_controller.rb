class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks= current_user.tasks.page(params[:page])
  end

  def show
  end

  def new
      @task = Task.new
  end

  def create
     @task = current_user.tasks.build(task_params)

    if @task.save
      flash[:success] = 'Taskが正常に投稿されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task が投稿されませんでした'
      render :new 
  end
end

  def edit
  end

  def update

    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @task
    else
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end

  def destroy
        @task.destroy

    flash[:success] = 'Taskは正常に削除されました'
    redirect_to :action => 'index'
  end

  private
  
  def set_task
    @task = Task.find_by(id: params[:id])
    unless @task && @task.user == current_user
      redirect_to root_path
    end
  end

   # Strong Parameter
  def task_params
     params.require(:task).permit(:content, :status)
  end  
end