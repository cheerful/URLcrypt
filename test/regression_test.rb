# encoding: utf-8
class URLcryptRegressionTest < TestClass
  def setup
    # this key was generated via rake secret in a rails app, the pack() converts it into a byte array
    @secret = ['d25883a27b9a639da85ea7e159b661218799c9efa63069fac13a6778c954fb6d721968887a19bdb01af8f59eb5a90d256bd9903355c20b0b4b39bf4048b9b17b'].pack('H*')
    URLcrypt::key = @secret
  end

  def test_encryption_and_decryption
    original = '{"some":"json_data","token":"dfsfsdfsdf"}'
    encrypted = URLcrypt.encrypt(original)

    encrypted = URLcrypt::encrypt(original)
    assert_equal(URLcrypt::decrypt(encrypted), original)
  end

  def test_encryption_with_too_long_key
    assert OpenSSL::Cipher.new('aes-256-cbc').key_len < @secret.bytesize

    original  = "hello world!"
    encrypted = URLcrypt::encrypt(original)
    assert_equal(URLcrypt::decrypt(encrypted), original)
  end

  def test_encryption_and_decryption_with_too_long_key
    assert OpenSSL::Cipher.new('aes-256-cbc').key_len < @secret.bytesize

    original = '{"some":"json_data","token":"dfsfsdfsdf"}'
    encrypted = URLcrypt.encrypt(original)

    encrypted = URLcrypt::encrypt(original)
    assert_equal(URLcrypt::decrypt(encrypted), original)
  end
end