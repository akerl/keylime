require 'userinput'
require 'yaml'

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
      @keychain = keychain || '~/.keylime'
    end

    def where(fields = {})
      fields = stringify(fields)
      entries.select do |x|
        fields.all? { |k, v| x[k] == v }
      end
    end

    def create(fields = {})
      raise('No fields given') if fields.empty?
      fields = stringify(fields)
      new = entries
      new << FileKeychainObject.new(fields)
      write_file! new
    end

    def delete(fields = {})
      raise('No fields given') if fields.empty?
      fields = stringify(fields)
      new = entries.select do |x|
        fields.any? { |k, v| x[k] != v }
      end
      write_file! new
    end

    private

    def entries
      create_file! unless File.exist? file
      YAML.safe_load(File.read(file))['credentials'].map do |x|
        x[:ref] = self
        FileKeychainObject.new(x)
      end
    end

    def create_file!
      write_file!([])
    end

    def write_file!(entries)
      File.open(file, 'w') do |fh|
        fh << YAML.dump('credentials' => entries.map(&:fields))
      end
    end

    def file
      @file ||= File.expand_path @keychain
    end

    def stringify(fields)
      fields.map { |k, v| [k.to_s, v] }.to_h
    end
  end

  ##
  # Object for stub file keychain
  class FileKeychainObject
    attr_reader :fields

    def initialize(params = {})
      @ref = params.delete(:ref)
      @fields = params
    end

    def delete
      @ref.delete(@fields)
    end

    def respond_to_missing?(method, _)
      @fields.include?(method.to_s) || super
    end

    def method_missing(sym, *args, &block)
      @fields[sym.to_s] || super
    end
  end
end
