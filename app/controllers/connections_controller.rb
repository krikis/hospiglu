class ConnectionsController < ApplicationController

  # GET /connections.json
  def index
    if Graffle.find_by_id(params[:graffle_id])
      @connections = Connection.where(graffle_id: params[:graffle_id])
    else
      @connections = Connection.all
    end

    respond_to do |format|
      format.json { render json: @connections }
    end
  end

  # POST /connections.json
  def create
    @connection = Connection.new(connection_params)

    respond_to do |format|
      if @connection.save
        format.json { render json: @connection, status: :created, location: @connection }
      else
        format.json { render json: @connection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /connections/1.json
  def update
    @connection = Connection.find(params[:id])

    respond_to do |format|
      if @connection.update_attributes(connection_params)
        format.json { head :no_content }
      else
        format.json { render json: @connection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /connections/1.json
  def destroy
    @connection = Connection.find(params[:id])
    @connection.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  # Use this method to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def connection_params
    params.require(:connection).permit(:graffle_id, :in_menu, :properties, :start_shape_id, :end_shape_id)
  end

end
