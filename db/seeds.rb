# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# ruby encoding: utf-8

User.create(email: "test@gamil.com", crypted_password: "admin", passowrd_salt: "admin", fullname: "administrador", username: "admin", role: "admin", login: "admin")

status_list = [
  [ "clientes", "ACTIVO" ],
  [ "clientes", "SUSPENDIDO" ],
  [ "clientes", "BAJA" ],
  [ "productos", "ACTIVO" ],
  [ "productos", "INACTIVO" ],
  [ "ip_address", "LIBRE" ],
  [ "ip_address", "OCUPADA" ],
  [ "calendario", "ACTIVO" ],
  [ "calendario", "CERRADO" ],
  [ "pagos", "EN TIEMPO" ],
  [ "pagos", "ATRASADO" ],
  [ "pagos", "PAGADO" ]
]

status_list.each do |tabla, status|
  Status.create( tabla: tabla, status: status )
end


status_list2 = [
  [ "MENSUAL"],
  [ "BIMESTRAL"],
  [ "TRIMESTRAL"],
  [ "SEMESTRAL"],
  [ "ANUAL"]
]

status_list2.each do |periodo|
  PaymentType.create( periodo: periodo )
end
