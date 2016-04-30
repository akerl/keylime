require 'spec_helper'
require 'securerandom'

describe Keylime::Credential do
  let(:subject) { Keylime.new(service: 'testing') }
  let(:secret) { SecureRandom.hex }

  it 'accepts a keychain path' do
    credential = Keylime.new(keychain: 'other/file', service: 'testing')
    credential.set secret
    expect(credential.get.keychain).to eql 'other/file'
  end
  it 'can get internet passwords' do
    credential = Keylime.new(server: 'https://example.org', account: 'testing')
    credential.set secret
    expect(credential.get.password).to eql secret
  end
  it 'can get generic passwords' do
    subject.set secret
    expect(subject.get.password).to eql secret
  end

  describe '#get' do
    it 'returns a credential if it exists' do
      subject.set secret
      expect(subject.get.password).to eql secret
    end
    it 'returns nil if the credential does not exist' do
      expect(subject.get).to be_nil
    end
  end

  describe '#get!' do
    it 'returns a credential if it exists' do
      subject.set secret
      expect(subject.get.password).to eql secret
    end
    it 'prompts the user if the credential does not exist' do
      allow(STDIN).to receive(:gets) { "#{secret}\n" }
      expect(STDOUT).to receive(:print).with('Question? ')
      expect(subject.get!('Question').password).to eql secret
    end
  end

  describe '#set' do
    it 'sets the value of the credential' do
      subject.set secret
      expect(subject.get.password).to eql secret
    end
    it 'overwrites any existing credential' do
      subject.set 'oldvalue'
      expect(subject.get.password).to eql 'oldvalue'
      subject.set secret
      expect(subject.get.password).to eql secret
    end
  end

  describe '#delete!' do
    it 'removes the credential' do
      subject.set secret
      expect(subject.get.password).to eql secret
      subject.delete!
      expect(subject.get).to be_nil
    end
    it 'succeeds if credential does not exist' do
      subject.delete!
      expect(subject.get).to be_nil
    end
  end
end
