class TodosController < ApplicationController
  # GET /todos
  # GET /todos.json
  def index
    @todos = Todo.where('username = ?', params[:username]).order('position')

    respond_to do |format|
      # format.html # index.html.erb
      format.json { render json: @todos }
    end
  end

  # GET /todos/1
  # GET /todos/1.json
  def show
    respond_to do |format|
      # format.html # index.html.erb
      format.json { render json: @todo }
    end
  end

  # GET /todos/new
  def new
    @todo = Todo.new
  end

  # GET /todos/1/edit
  def edit
    @todo = Todo.find(params[:id])
  end

  # POST /todos
  # POST /todos.json
  def create
    @todo = Todo.new(todo_params)

    count = Todo.where(:username => params[:todo][:username]).count

    too_fresh_todo = Todo.where("username = ? AND created_at > ?", params[:todo][:username], 5.seconds.ago.to_s(:db)).first

    if count > 1000 || too_fresh_todo
      render :json => Todo.new
      return
    end

    respond_to do |format|
      if @todo.save
        # format.html { redirect_to @todo, notice: 'Todo was successfully created.' }
        format.json { render :show, status: :created, location: @todo }
      else
        # format.html { render :new }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todos/1
  # PATCH/PUT /todos/1.json
  def update
    @todo = Todo.find(params[:id])

    respond_to do |format|
      if @todo.update_attributes(todo_params)
        # format.html { redirect_to @todo, notice: 'Todo was successfully updated.' }
        format.json { render :show, status: :ok, location: @todo }
      else
        # format.html { render :edit }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todos/1
  # DELETE /todos/1.json
  def destroy
    @todo = Todo.find_by!(id: params[:id], username: params[:username])
    @todo.destroy

    respond_to do |format|
      # format.html { redirect_to todos_url, notice: 'Todo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /todos/sort.json
  def sort
    params[:todos].each_with_index do |id, index|
      Todo.where('username = ? AND id = ?', params[:username], id).update_all(position: index + 1)
    end

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def todo_params
      params.require(:todo).permit(:label, :username, :position)
    end
end
