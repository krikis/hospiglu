class GrafflesController < ApplicationController

  # GET /graffles
  # GET /graffles.json
  def index
    if params[:brainstorm_id].present?
      @graffles = Graffle.where(brainstorm_id: params[:brainstorm_id])
    else
      @graffles = Graffle.all
    end
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
  def show
    @graffles = Graffle.all
    if graffle = Graffle.find_by_id(params[:id]) || @graffles.first
      @graffle_id = graffle.id
      @shapes = graffle.shapes || []
      @connections = graffle.connections || []
    end

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # POST /graffles.json
  def create
    @graffle = Graffle.new(graffle_params)

    respond_to do |format|
      if @graffle.save
        format.json { render json: @graffle, status: :created, location: @graffle }
      else
        format.json { render json: @graffle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /graffles/1.json
  def update
    @graffle = Graffle.find(params[:id])

    respond_to do |format|
      if @graffle.update_attributes(graffle_params)
        format.json { head :no_content }
      else
        format.json { render json: @graffle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /graffles/1.json
  def destroy
    @graffle = Graffle.find(params[:id])
    @graffle.destroy unless @graffle.in_menu

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  # Use this method to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def graffle_params
    params.require(:graffle).permit(:brainstorm_id, :graffle_type, :properties)
  end

end
