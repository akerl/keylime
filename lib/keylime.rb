##
# Keylime, a simple tool for interacting with OSX's keychain
module Keylime
  class << self
    def new(*args)
      self::Credential.new(*args)
    end
  end
end

require 'keylime/credential'
