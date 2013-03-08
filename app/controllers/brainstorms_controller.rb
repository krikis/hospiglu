class BrainstormsController < ApplicationController
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

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def brainstorm_params
      params.require(:brainstorm).permit()
    end
end
