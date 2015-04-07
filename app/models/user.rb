class User < ActiveRecord::Base

  acts_as_authentic do |config|
    config.crypto_provider = Authlogic::CryptoProviders::Sha512
    config.transition_from_crypto_providers = Authlogic::CryptoProviders::BCrypt
    config.require_password_confirmation = true
    config.login_field = :email
  end

  def self.find_by_email_or_persistence_token(login)
    find_by("LOWER(email) = ?", login.to_s.downcase) || find_by_persistence_token(login.to_s)
  end

end
