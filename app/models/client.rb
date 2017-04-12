class Client < ActiveRecord::Base
  belongs_to :sectorial
  belongs_to :payment_type
  belongs_to :product
  belongs_to :status
  validates :fullname, :direccion, :email, :fecha_inicio, :payment_type_id, :status_id, :sectorial_id, :ip_address, :product_id, presence: true
  validates :tel, numericality: { only_integer: true }, presence: true
  before_create :grabar_ip
  before_save :checar_role

  def checar_role
    self.role.upcase
  end
  def grabar_ip
    ip = self.ip_address
    sectorial = self.sectorial_id
    ip_status = IpAddress.find_by_ip_address(ip)

    if ip_status.nil?
      puts "No existe Dirección Ip"
      tabla_ip = IpAddress.new(:ip_address => ip, :sectorial_id => sectorial, :status_id => 7)
      tabla_ip.save
    else
      if ip_status.status_id == "OCUPADA"
        puts "Dirección IP Ocupada"
        errors.add('Ip_Address: ', "La dirección Ip ya existe, Favor de seleccionar una diferente")
        format.html { render :new, @client.errors }
      else
        puts "Dirección IP ya existe pero esta Libre"
        tabla_ip = IpAddress.update(ip_status.id, :status_id => 7)
      end
    end
  end

end
