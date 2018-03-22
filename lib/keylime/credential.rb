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
      @keychain = FileKeychain.new(@options[:keychain]) unless Keylime::ENABLED
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
  class FileKeychain
    def initialize(keychain)
      @keychain = keychain
    end

    def segment
      @segment ||= FileKeychainSegment.new(@keychain)
    end
    alias internet_passwords segment
    alias generic_passwords segment
  end

  ##
  # Stub segment for if keylime is running on a non-Mac
  class FileKeychainSegment
    def initialize(keychain)
      @keychain = keychain || 'default'
    end

    def where(options = {})
      entries.select do |x|

      end
    end

    def create(_)
    end

    def entries
      create_file! unless File.exist? file
      YAML.parse(File.read(file))['credentials']
    end

    def create_file!
      File.open(file, 'w') do |fh|
        fh << YAML.dump({'credentials': []})
      end
    end

    def file
      @file ||= File.join(dir, @keychain)
    end

    def dir
      @dir ||= File.expand_path('~/.keylime')
    end
  end

  class FileKeychainObject
    attr_reader :server, :service, :account, :password

    def initialize(params = {})
      @server = params[:server]
      @service = params[:service]
      @account = params[:account]
      @password = params[:password]
    end

    def delete

    end
  end
end
