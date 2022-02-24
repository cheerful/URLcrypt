# encoding: utf-8
require 'test_helper'

class URLcryptEncryptionTest < TestClass
  def teardown
    ENV["urlcrypt_key"] = nil
  end

  def test_requires_ENV_if_no_key_provided
    error = assert_raises(KeyError) do
      ::URLcrypt::decrypt("just some plaintext")
    end
    assert_equal error.message, "key not found: \"urlcrypt_key\""

    error = assert_raises(KeyError) do
      ::URLcrypt::encrypt("just some plaintext")
    end
    assert_equal error.message, "key not found: \"urlcrypt_key\""
  end

  def test_encryption_with_ENV_key
    # pack() converts this secret into a byte array
    secret = ['d25883a27b9a639da85ea7e159b661218799c9efa63069fac13a6778c954fb6d'].pack('H*')
    ENV['urlcrypt_key'] = secret

    assert_equal  OpenSSL::Cipher.new('aes-256-cbc').key_len, secret.bytesize

    original  = "hello world!"
    encrypted = URLcrypt::encrypt(original)
    assert_equal(URLcrypt::decrypt(encrypted), original)
  end

  def test_decrypt_error_with_ENV_key
    secret = ['d25883a27b9a639da85ea7e159b661218799c9efa63069fac13a6778c954fb6d'].pack('H*')
    ENV['urlcrypt_key'] = secret
    error = assert_raises(URLcrypt::DecryptError) do
      ::URLcrypt::decrypt("just some plaintext")
    end
    assert_equal error.message, "not a valid string to decrypt"
  end

  def test_encryption_with_explicit_key
    # pack() converts this secret into a byte array
    secret = ['d25883a27b9a639da85ea7e159b661218799c9efa63069fac13a6778c954fb6d'].pack('H*')

    assert_equal  OpenSSL::Cipher.new('aes-256-cbc').key_len, secret.bytesize

    original  = "hello world!"
    encrypted = URLcrypt::encrypt(original, key: secret)
    assert_equal(URLcrypt::decrypt(encrypted, key: secret), original)
  end

  def test_decrypt_error_with_explicit_key
    secret = ['d25883a27b9a639da85ea7e159b661218799c9efa63069fac13a6778c954fb6d'].pack('H*')
    error = assert_raises(URLcrypt::DecryptError) do
      ::URLcrypt::decrypt("just some plaintext", key: secret)
    end
    assert_equal error.message, "not a valid string to decrypt"
  end

  def test_threads_with_ENV_keys
    # pack() converts this secret into a byte array
    secret = ['d25883a27b9a639da85ea7e159b661218799c9efa63069fac13a6778c954fb6d'].pack('H*')
    ENV['urlcrypt_key'] = secret

    assert_equal  OpenSSL::Cipher.new('aes-256-cbc').key_len, secret.bytesize

    parent_string  = "hello world!"
    parent_encrypted = URLcrypt::encrypt(parent_string)
    assert_equal(URLcrypt::decrypt(parent_encrypted), parent_string)

    threads = 100.times.map do |n|
      Thread.new{
        original = "Test String #{n}"
        encrypted = URLcrypt::encrypt(original)
        assert_equal(URLcrypt::decrypt(encrypted), original)

        thread_encrypted = URLcrypt::encrypt(parent_string)

        assert_equal(URLcrypt::decrypt(thread_encrypted), parent_string)
        assert_equal(URLcrypt::decrypt(parent_encrypted), parent_string)
      }
    end

    threads.each { |thr| thr.join }
  end

  def test_threads_with_explicit_per_thread_keys
    threads = 100.times.map do |n|
      Thread.new{
        key = ["d25883a27b9a639da85ea7e159b661218799c9efa63069fac13a6778c954fb6d-secret-key-#{n}"].pack('H*')
        original = "Test String #{n}"
        encrypted = URLcrypt::encrypt(original, key: key)
        assert_equal(URLcrypt::decrypt(encrypted, key: key), original)
      }
    end

    threads.each { |thr| thr.join }
  end

  def test_threads_with_explicit_per_thread_keys_overriding_ENV_variable
    secret = ['d25883a27b9a639da85ea7e159b661218799c9efa63069fac13a6778c954fb6d'].pack('H*')
    ENV['urlcrypt_key'] = secret

    threads = 100.times.map do |n|
      Thread.new{
        key = ["d25883a27b9a639da85ea7e159b661218799c9efa63069fac13a6778c954fb6d-secret-key-#{n}"].pack('H*')

        original = "Test String #{n}"
        encrypted = URLcrypt::encrypt(original, key: key)
        assert_equal(URLcrypt::decrypt(encrypted, key: key), original)

        parent_encryption = URLcrypt::encrypt(original)
        refute_equal parent_encryption, encrypted
      }
    end

    threads.each { |thr| thr.join }
  end
end