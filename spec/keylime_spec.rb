require 'spec_helper'

describe Keylime do
  describe '#new' do
    it 'creates Credential objects' do
      expect(Keylime.new).to be_an_instance_of Keylime::Credential
    end
  end
end
