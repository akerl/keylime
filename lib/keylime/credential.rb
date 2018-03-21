require 'userinput'

module Keylime
  ENABLED = begin
    require 'keychain'
    true
  rescue LoadError
    raise if RUBY_PLATFORM =~ /darwin/
    false
  end

  ##
  # Easy wrapper around getting and setting secrets
  class Credential
    def initialize(params = {})
      @options = params
    end

    def get
      keychain_segment.where(@options).first
    end

    def get!(message)
      get || prompt(message)
    end

    def set(value)
      delete!
      keychain_segment.create(@options.merge(password: value))
    end

    def delete!
      get && keychain_segment.where(@options).first.delete
      nil
    end

    private

    def prompt(message)
      set UserInput.new(
        message: message,
        secret: true,
        attempts: 3,
        validation: /.+/
      ).ask
    end

    def keychain
      return @keychain if @keychain
      @keychain = StubKeychain.new unless Keylime::ENABLED
      @keychain ||= Keychain.open(@options[:keychain]) if @options[:keychain]
      @keychain ||= Keychain
    end

    def key_type
      @options[:server] ? :internet_passwords : :generic_passwords
    end

    def keychain_segment
      @keychain_segment ||= keychain.send(key_type)
    end
  end

  ##
  # Stub keychain for if keylime is running on a non-Mac
  class StubKeychain
    def segment
      StubKeychainSegment.new
    end
    alias internet_passwords segment
    alias generic_passwords segment
  end

  ##
  # Stub segment for if keylime is running on a non-Mac
  class StubKeychainSegment
    def where(_)
      []
    end

    def create() end
  end
end
