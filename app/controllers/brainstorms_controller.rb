class BrainstormsController < ApplicationController

  before_filter :init_from_session
  before_filter :validate_session,
                only: [:first_department, :second_department, :your_department, :voting, :consolidation]

  def participate
    @user = User.new

    render layout: 'dialog'
  end

  def enroll
    @brainstorm ||= (Brainstorm.where(state: 'open').first || Brainstorm.create)
    unless @user and @user.name == user_params[:name] and @user.brainstorm == @brainstorm
      @user = User.new(user_params)
    end
    @user.brainstorm = @brainstorm
    if @user.save
      session[:brainstorm_id] = @brainstorm.id
      session[:user_id] = @user.id
      redirect_to current_phase_path
    else
      render action: 'participate', layout: 'dialog'
    end
  end

  def first_department
    render template: 'brainstorms/start_application'
  end

  def second_department
    render template: 'brainstorms/start_application'
  end

  def your_department
    render template: 'brainstorms/start_application'
  end

  def voting
    @brainstorm.update_attributes state: 'closed'
    render template: 'brainstorms/start_application'
  end

  def consolidation
    render template: 'brainstorms/start_application'
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

  def init_from_session
    @brainstorm = Brainstorm.find_by_id session[:brainstorm_id]
    @user = User.find_by_id session[:user_id]
    if @brainstorm
      @users = @brainstorm.users
      @graffles = @brainstorm.graffles
      @shapes = Shape.where graffle_id: @brainstorm.current_graffles_with(@user).map(&:id)
      @connections = Connection.where graffle_id: @brainstorm.current_graffles_with(@user).map(&:id)
    end
  end

  def validate_session
    if @brainstorm and @user
      unless @brainstorm.phase == params[:action]
        redirect_to current_phase_path
      end
    else
      redirect_to action: 'participate'
    end
  end

  def current_phase_path
    send "#{@brainstorm.phase}_brainstorms_path"
  end

  # Use this methods to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def user_params
    params.require(:user).permit(:name)
  end

  def brainstorm_params
    params.require(:brainstorm).permit(:phase, :state)
  end
end
