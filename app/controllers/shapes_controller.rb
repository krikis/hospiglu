class ShapesController < ApplicationController

  # GET /shapes.json
  def index
    if params[:graffle_ids].present?
      @shapes = Shape.where(graffle_id: params[:graffle_ids])
    elsif params[:brainstorm_id].present?
      @shapes = Shape.includes(:graffle).where('graffles.brainstorm_id = ?', params[:brainstorm_id])
    else
      @shapes = Shape.all
    end

    respond_to do |format|
      format.json { render json: @shapes }
    end
  end

  # POST /shapes.json
  def create
    @shape = Shape.new(shape_params)

    respond_to do |format|
      if @shape.save
        format.json { render json: @shape, status: :created, location: @shape }
      else
        format.json { render json: @shape.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shapes/1.json
  def update
    @shape = Shape.find(params[:id])

    respond_to do |format|
      if @shape.update_attributes(shape_params)
        format.json { head :no_content }
      else
        format.json { render json: @shape.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shapes/1.json
  def destroy
    @shape = Shape.find(params[:id])
    @shape.destroy unless @shape.in_menu

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  # Use this method to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def shape_params
    params.require(:shape).permit(:graffle_id, :in_menu, :properties)
  end

end
