class GrafflesController < ApplicationController
  # GET /graffles
  # GET /graffles.json
  def index
    @graffles = Graffle.all
    if graffle = @graffles.first
      @shapes = graffle.shapes
      @connections = graffle.connections
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @graffles }
    end
  end

  # GET /graffles/1
  # GET /graffles/1.json
  def show
    @graffle = Graffle.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @graffle }
    end
  end

  # GET /graffles/new
  # GET /graffles/new.json
  def new
    @graffle = Graffle.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @graffle }
    end
  end

  # GET /graffles/1/edit
  def edit
    @graffle = Graffle.find(params[:id])
  end

  # POST /graffles
  # POST /graffles.json
  def create
    @graffle = Graffle.new(graffle_params)

    respond_to do |format|
      if @graffle.save
        format.html { redirect_to @graffle, notice: 'Graffle was successfully created.' }
        format.json { render json: @graffle, status: :created, location: @graffle }
      else
        format.html { render action: "new" }
        format.json { render json: @graffle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /graffles/1
  # PATCH/PUT /graffles/1.json
  def update
    @graffle = Graffle.find(params[:id])

    respond_to do |format|
      if @graffle.update_attributes(graffle_params)
        format.html { redirect_to @graffle, notice: 'Graffle was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @graffle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /graffles/1
  # DELETE /graffles/1.json
  def destroy
    @graffle = Graffle.find(params[:id])
    @graffle.destroy

    respond_to do |format|
      format.html { redirect_to graffles_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def graffle_params
      params.require(:graffle).permit()
    end
end
