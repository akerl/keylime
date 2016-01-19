module Keylime
  class << self
    def new(*args)
      self::Credential.new(*args)
    end
  end
end
