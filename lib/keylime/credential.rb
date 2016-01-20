require 'keychain'
require 'userinput'

module Keylime
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

    def prompt(message)
      set UserInput.new(
        message: message,
        secret: true,
        attempts: 3,
        validation: /.+/
      ).ask
    end

    def set(value)
      get && delete
      keychain_segment.create(@options.merge(password: value))
    end

    def delete
      keychain_segment.where(@options).first.delete
    end

    private

    def keychain
      @keychain ||= if @options[:keychain]
                      Keychain.open(@options[:keychain])
                    else
                      Keychain
                    end
    end

    def key_type
      @options[:server] ? :internet_passwords : :generic_passwords
    end

    def keychain_segment
      @keychain_segment ||= keychain.send(key_type)
    end
  end
end
