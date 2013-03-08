class BrainstormsController < ApplicationController

  before_filter :init_from_session

  layout 'dialog'

  def participate
    @user = User.new
  end

  def enroll
    @brainstorm ||= Brainstorm.where(state: 'open').first || Brainstorm.create
    @user = User.new(user_params)
    if @user.save
      session[:brainstorm_id] ||= @brainstorm.id
      session[:user_id] = @user.id
      @brainstorm.update_attributes phase: 'first_department'
      redirect_to next_phase_path
    else
      render action: 'participate'
    end
  end

  def first_department
    @graffles = @brainstorm.graffles
    @shapes = @brainstorm.current_graffle.shapes
    @connections = @brainstorm.current_graffle.connections
  end

  def second_department
    @graffles = @brainstorm.graffles
    @shapes = @brainstorm.current_graffle.shapes
    @connections = @brainstorm.current_graffle.connections
  end

  def your_department
    @graffles = @brainstorm.graffles
    @shapes = @brainstorm.current_graffle.shapes
    @connections = @brainstorm.current_graffle.connections
  end

  def voting
    @brainstorm.update_attributes state: 'closed'
    @users = @brainstorm.users
    @graffles = @users.map(&:your_department_graffle)
    if graffle = @graffles.first
      @shapes = graffle.shapes
      @connections = graffle.connections
    end
  end

  def consolidation
    @graffles = @brainstorm.graffles
    @shapes = @brainstorm.current_graffle.shapes
    @connections = @brainstorm.current_graffle.connections
  end

  # GET /brainstorms
  # GET /brainstorms.json
  def index
    @brainstorms = Brainstorm.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @brainstorms }
    end
  end

  # GET /brainstorms/1
  # GET /brainstorms/1.json
  def show
    @brainstorm = Brainstorm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @brainstorm }
    end
  end

  # GET /brainstorms/new
  # GET /brainstorms/new.json
  def new
    @brainstorm = Brainstorm.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @brainstorm }
    end
  end

  # GET /brainstorms/1/edit
  def edit
    @brainstorm = Brainstorm.find(params[:id])
  end

  # POST /brainstorms
  # POST /brainstorms.json
  def create
    @brainstorm = Brainstorm.new(brainstorm_params)

    respond_to do |format|
      if @brainstorm.save
        format.html { redirect_to @brainstorm, notice: 'Brainstorm was successfully created.' }
        format.json { render json: @brainstorm, status: :created, location: @brainstorm }
      else
        format.html { render action: "new" }
        format.json { render json: @brainstorm.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /brainstorms/1
  # PATCH/PUT /brainstorms/1.json
  def update
    @brainstorm = Brainstorm.find(params[:id])

    respond_to do |format|
      if @brainstorm.update_attributes(brainstorm_params)
        format.html { redirect_to @brainstorm, notice: 'Brainstorm was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @brainstorm.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /brainstorms/1
  # DELETE /brainstorms/1.json
  def destroy
    @brainstorm = Brainstorm.find(params[:id])
    @brainstorm.destroy

    respond_to do |format|
      format.html { redirect_to brainstorms_url }
      format.json { head :no_content }
    end
  end

  private

  def next_phase_path
    send "#{@brainstorm.next_phase}_brainstorms_path"
  end

  # Use this method to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def user_params
    params.require(:user).permit(:name)
  end
end
