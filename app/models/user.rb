class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::Sha512
  end
  before_save :checar_role

  def checar_role
    self.role.upcase
  end
  ROLES = %w[ADMIN GENERAL PAGOS]

end
