# encoding: utf-8
require 'test_helper'

class TestURLcrypt < TestClass
  def test_empty_string
    assert_encode_and_decode('', '')
  end

  def test_encode
    assert_encode_and_decode(
      '111gc86f4nxw5zj1b3qmhpb14n5h25l4m7111',
      "\0\0awesome \n ü string\0\0")
  end

  def test_invalid_encoding
    assert_decoding('ZZZZZ', '')
  end

  def test_arbitrary_byte_strings
    0.step(1500,17) do |n|
      original = (0..n).map{rand(256).chr}.join
      encoded = URLcrypt::encode(original)
      assert_decoding(encoded, original)
    end
  end
end
