class ClientsController < ApplicationController
  #load_and_authorize_resource
  #respond_to :html, :xml, :json, :pdf, :xlsx, :csv
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  # GET /clients
  # GET /clients.json
  def index
    if params[:q]
      @q = Client.ransack(params[:q])
      @clients = @q.result.paginate(:page => params[:page], :per_page => 50).order(:id)
    else
      @q = Client.ransack(params[:q])
      @clients = Client.all.paginate(:page => params[:page], :per_page => 50).order(:id)
    end

    respond_to do |format|
      format.html
      format.json
      format.pdf { render_oficiosp_list(@clients) }
      format.csv { send_data @clients.to_csv }
      format.xlsx
    end
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
  end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        format.html { redirect_to @client, notice: 'Cliente creado con excito.' }
        format.json { render :show, status: :created, location: @client }
        format.xlsx
      else
        format.html { render :new }
        format.json { render json: @client.errors, status: :unprocessable_entity }
        format.xlsx
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to @client, notice: 'Cliente actualizado correctamente.' }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client.destroy
    respond_to do |format|
      format.html { redirect_to clients_url, notice: 'Cliente eliminado.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(:fullname, :direccion, :tel, :email, :fecha_inicio, :fecha_termino, :payment_type_id, :status_id, :sectorial_id, :ip_address, :product_id)
    end
end
