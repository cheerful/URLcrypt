# encoding: utf-8
require 'bundler'
Bundler.require(:default, :test)

require 'simplecov'
SimpleCov.start

require "minitest/autorun"

class TestClass < Minitest::Test
  require 'URLcrypt'

  def assert_bytes_equal(string1, string2)
    bytes1 = string1.bytes.to_a.join(':')
    bytes2 = string2.bytes.to_a.join(':')
    assert_equal(bytes1, bytes2)
  end
  
  def assert_decoding(encoded, plain)
    decoded = URLcrypt.decode(encoded)
    assert_bytes_equal(plain, decoded)
  end

  def assert_encoding(encoded, plain)
    actual = URLcrypt.encode(plain)
    assert_bytes_equal(encoded, actual)
  end

  def assert_encode_and_decode(encoded, plain)
    assert_encoding(encoded, plain)
    assert_decoding(encoded, plain)
  end
end