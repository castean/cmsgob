class CalendarsController < ApplicationController
  #load_and_authorize_resource
  before_action :set_calendar, only: [:show, :edit, :update, :destroy]

  # GET /calendars
  # GET /calendars.json
  def index
    @calendars = Calendar.all
  end

  # GET /calendars/1
  # GET /calendars/1.json
  def show
  end

  # GET /calendars/new
  def new
    @calendar = Calendar.new
  end

  # GET /calendars/1/edit
  def edit
  end

  # POST /calendars
  # POST /calendars.json
  def create
    @calendar = Calendar.new(calendar_params)
    respond_to do |format|
      unico = Calendar.find_by_status_id(8)
      if unico.nil?
        if @calendar.save
          crear_pagos(@calendar.id)
          format.html { redirect_to @calendar, notice: 'Calendar creado satisfactoriamente.' }
          format.json { render :show, status: :created, location: @calendar }
        else
          format.html { render :new }
          format.json { render json: @calendar.errors, status: :unprocessable_entity }
        end
      else
        errors.add('status: ', "Existe un Calendario Abierto, Favor de cerrarlo antes de abrir uno Nuevo")
        format.html { render :new, @calendar.errors }
      end
    end
  end

  # PATCH/PUT /calendars/1
  # PATCH/PUT /calendars/1.json
  def update
    respond_to do |format|
      if @calendar.update(calendar_params)
        format.html { redirect_to @calendar, notice: 'Calendar actualizado correctamente.' }
        format.json { render :show, status: :ok, location: @calendar }
      else
        format.html { render :edit }
        format.json { render json: @calendar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calendars/1
  # DELETE /calendars/1.json
  def destroy
    @calendar.destroy
    respond_to do |format|
      format.html { redirect_to calendars_url, notice: 'Calendar was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calendar
      @calendar = Calendar.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def calendar_params
      params.require(:calendar).permit(:calendario, :fecha_corte, :status_id)
    end

    def calculameses(ca, c)
      difmes = ca.year - c.year
      case difmes
      when 0
        meses = ca.month - c.month
        return meses
      when 1
        mesesa = 12 - ca.month
        meses = mesesa + (ca.month - c.month)
        return meses
      else
        meses = ( ((calendario_id.fecha_corte).year - c.fecha_inicio.year) * 12) + ((calendario_id.fecha_corte).month - c.fecha_inicio.month)
        return meses
      end
    end


    def revisacobro(meses, periodo)
      if meses != periodo
        restante = (meses/periodo)
        if restante == 0
          aplicable = false
          return aplicable
        else
          while (restante != 0 && restante == periodo)
              restante = restante/periodo
          end
          case restante
            when restante == periodo
              aplicable = true
            when 1
              aplicable = true
            else
              aplicable = false
          end
        end
      else
        return aplicable = true
      end

    end

    def crear_pagos(calendario)
      calendario_id = Calendar.find_by_status_id(8)
      cliente = Client.where(status_id: 1)
      cliente.each do |c|
        periodo = c.payment_type_id
        case periodo
          when 1
            if c.fecha_inicio.year == calendario_id.fecha_corte.year
                if c.fecha_inicio.month ==  calendario_id.fecha_corte.month
                  pay = Payment.new(:calendar_id => calendario_id.id, :client_id => c.id, :fecha_corte => calendario_id.fecha_corte, :fecha_limite => calendario_id.fecha_corte + 5.days, :saldo => c.product.costo)
                  pay.save
                else
                  if c.fecha_inicio.day <= 10
                    pay = Payment.new(:calendar_id => calendario_id.id, :client_id => c.id, :fecha_corte => calendario_id.fecha_corte, :fecha_limite => calendario_id.fecha_corte + 5.days, :saldo => c.product.costo)
                    pay.save
                  else
                    saldo = c.product.costo/(calendario_id.fecha_corte.day - c.fecha_inicio.day)
                    pay = Payment.new(:calendar_id => calendario_id.id, :client_id => c.id, :fecha_corte => calendario_id.fecha_corte, :fecha_limite => calendario_id.fecha_corte + 5.days, :saldo => saldo)
                    pay.save
                  end
                end
            else
              pay = Payment.new(:calendar_id => calendario_id.id, :client_id => c.id, :fecha_corte => calendario_id.fecha_corte, :fecha_limite => calendario_id.fecha_corte + 5.days, :saldo => c.product.costo)
              pay.save
            end
          when 2
            #meses = ( ((calendario_id.fecha_corte).year - c.fecha_inicio.year) * 12) + ((calendario_id.fecha_corte).month - c.fecha_inicio.month)
            #aplica = meses%2
            meses = calculameses(calendario_id.fecha_corte, c.fecha_inicio)
            aplica = revisacobro(meses,2)
            if aplica == true
              pay = Payment.new(:calendar_id => calendario_id.id, :client_id => c.id, :fecha_corte => calendario_id.fecha_corte, :fecha_limite => calendario_id.fecha_corte + 5.days, :saldo => (c.product.costo * 2))
              pay.save
            end
          when 3
            #meses = ( ((calendario_id.fecha_corte).year - c.fecha_inicio.year) * 12) + ((calendario_id.fecha_corte).month - c.fecha_inicio.month)
            #aplica = meses%3
            meses = calculameses(calendario_id.fecha_corte, c.fecha_inicio)
            aplica = revisacobro(meses,3)
            if aplica == true
              pay = Payment.new(:calendar_id => calendario_id.id, :client_id => c.id, :fecha_corte => calendario_id.fecha_corte, :fecha_limite => calendario_id.fecha_corte + 5.days, :saldo => (c.product.costo * 3))
              pay.save
            end
          when 4
            #meses = ( ((calendario_id.fecha_corte).year - c.fecha_inicio.year) * 12) + ((calendario_id.fecha_corte).month - c.fecha_inicio.month)
            #aplica = meses%6
            meses = calculameses(calendario_id.fecha_corte, c.fecha_inicio)
            aplica = revisacobro(meses,6)
            if aplica == true
              pay = Payment.new(:calendar_id => calendario_id.id, :client_id => c.id, :fecha_corte => calendario_id.fecha_corte, :fecha_limite => calendario_id.fecha_corte + 5.days, :saldo => (c.product.costo * 6))
              pay.save
            end
          when 5
            #meses = ( ((calendario_id.fecha_corte).year - c.fecha_inicio.year) * 12) + ((calendario_id.fecha_corte).month - c.fecha_inicio.month)
            #aplica = meses%12
            meses = calculameses(calendario_id.fecha_corte, c.fecha_inicio)
            aplica = revisacobro(meses,12)
            if aplica == true
              pay = Payment.new(:calendar_id => calendario_id.id, :client_id => c.id, :fecha_corte => calendario_id.fecha_corte, :fecha_limite => calendario_id.fecha_corte + 5.days, :saldo => (c.product.costo * 12))
              pay.save
            end
        end
      end
    end

end
