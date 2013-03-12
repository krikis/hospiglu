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

  private

  # Use this method to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def graffle_params
    params.require(:graffle).permit()
  end

end
