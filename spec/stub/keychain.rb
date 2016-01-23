require 'ostruct'

module Keychain
  class << self
    def generic_passwords
      KeychainFile.new.generic_passwords
    end

    def internet_passwords
      KeychainFile.new.internet_passwords
    end

    def open(path)
      KeychainFile.new(path)
    end

    def nuke_list
      @nuke_list ||= []
    end

    def empty_nuke_list!
      @nuke_list = []
    end
  end

  class KeychainFile
    def initialize(path = nil)
      @keychain = path
    end

    def generic_passwords
      Passwords.new(@keychain)
    end

    def internet_passwords
      InternetPasswords.new(@keychain)
    end
  end

  class Passwords
    def initialize(keychain = nil)
      @keychain = keychain
    end

    def where(params)
      cache.find_all { |x| params.all? { |k, v| x[k] == v } }
    end

    def create(params)
      struct = OpenStruct.new(params)
      struct.keychain = @keychain
      cache << struct
    end

    private

    def cache
      @cache ||= []
      @cache.reject! { |x| Keychain.nuke_list.include? x.hash }
      Keychain.empty_nuke_list!
      @cache
    end
  end

  class InternetPasswords < Passwords
  end
end

class OpenStruct
  def delete
    Keychain.nuke_list << hash
    super
  end
end
