keylime
=========

[![Gem Version](https://img.shields.io/gem/v/keylime.svg)](https://rubygems.org/gems/keylime)
[![GitHub Workflow Status](https://img.shields.io/actions/github/workflow/status/akerl/keylime/build.yml?branch=main)](https://github.com/akerl/keylime/actions)
[![MIT Licensed](https://img.shields.io/badge/license-MIT-green.svg)](https://tldrlegal.com/license/mit-license)

Simple wrapper for using Mac Keychain

## Usage

Create a Keylime object, which represents a single credential (which may or may not be stored in Keychain yet):

```
require 'keylime'
my_credential = Keylime.new(server: 'https://example.org', account: 'akerl')
```

You can specify any of the following attributes by providing them:

* account: the username field
* server: the site the credential is for (if it's an "internet password", which just means a credential that was created with a server set)
* label: the name of the credential, generally describing what it's used for
* service: the "Where" field in keychain access, used to describe what the credential is used for
* There are other attributes, which you can look up with `security find-generic-password -h` and `security find-internet-password -h`, but these are the most commonly useful

Once you've created the credential object, you can get its value in one of two ways:

```
require 'keylime'
my_credential = Keylime.new(server: 'https://example.org', account: 'akerl')

# This will get the value, and return nil if it doesn't exist:
value = my_credential.get

# This will get the value, and prompt the user to input the value if it doesn't exist:
value = my_credential.get!('Please enter example.org password')
```

If you know the password via some other means, you can directly set it with .set():

```
require 'keylime'
my_credential = Keylime.new(server: 'https://example.org', account: 'akerl')

secret = 'foobar'
my_credential.set(secret)
```

You can also delete a secret using .delete():

```
require 'keylime'
my_credential = Keylime.new(server: 'https://example.org', account: 'akerl')

my_credential.delete!
```

## Installation

    gem install keylime

## License

keylime is released under the MIT License. See the bundled LICENSE file for details.

