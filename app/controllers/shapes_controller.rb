class ShapesController < ApplicationController
  # GET /shapes
  # GET /shapes.json
  def index
    if Graffle.find_by_id(params[:graffle_id])
      @shapes = Shape.where(graffle_id: params[:graffle_id])
    else
      @shapes = Shape.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shapes }
    end
  end

  # GET /shapes/1
  # GET /shapes/1.json
  def show
    @shape = Shape.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @shape }
    end
  end

  # GET /shapes/new
  # GET /shapes/new.json
  def new
    @shape = Shape.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @shape }
    end
  end

  # GET /shapes/1/edit
  def edit
    @shape = Shape.find(params[:id])
  end

  # POST /shapes
  # POST /shapes.json
  def create
    @shape = Shape.new(shape_params)

    respond_to do |format|
      if @shape.save
        format.html { redirect_to @shape, notice: 'Shape was successfully created.' }
        format.json { render json: @shape, status: :created, location: @shape }
      else
        format.html { render action: "new" }
        format.json { render json: @shape.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shapes/1
  # PATCH/PUT /shapes/1.json
  def update
    @shape = Shape.find(params[:id])

    respond_to do |format|
      if @shape.update_attributes(shape_params)
        format.html { redirect_to @shape, notice: 'Shape was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @shape.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shapes/1
  # DELETE /shapes/1.json
  def destroy
    @shape = Shape.find(params[:id])
    @shape.destroy

    respond_to do |format|
      format.html { redirect_to shapes_url }
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
