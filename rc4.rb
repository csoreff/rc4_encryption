class Rc4
  def initialize(str)
    @q1, @q2 = 0, 0
    @key = []
    str.each_byte { |elem| @key << elem } while @key.size < 256
    @key.slice!(256..@key.size - 1) if @key.size >= 256
    @s = (0..255).to_a
    # initial permutation of S
    j = 0
    0.upto(255) do |i|
      j = (j + @s[i] + @key[i]) % 256
      @s[i], @s[j] = @s[j], @s[i]
    end
  end

  # destructive method
  def encrypt!(text)
    process text
  end

  # normal encrypt, calls process method
  def encrypt(text)
    process text.dup
  end

  private

  # perform the XOR and returns the ciphertext as codepoint
  def process(text)
    0.upto(text.length - 1) { |i| text[i] = (text[i].ord ^ stream_generation).chr }
    text
  end

  def stream_generation
    @q1 = (@q1 + 1) % 256
    @q2 = (@q2 + @s[@q1]) % 256
    @s[@q1], @s[@q2] = @s[@q2], @s[@q1]
    @s[(@s[@q1] + @s[@q2]) % 256]
  end
end

puts 'Enter key.'
key_input = gets.chomp
key_input = key_input
encrypt_instance = Rc4.new(key_input)
decrypt_instance = Rc4.new(key_input)

puts 'Enter plaintext.'
plain_input = gets.chomp
plain_input = plain_input
cipher_text = encrypt_instance.encrypt(plain_input)

puts 'Plaintext is: ' + plain_input
puts 'cipher_text is: ' + cipher_text
decrypted_text = decrypt_instance.encrypt(cipher_text)
puts 'Decrypted text is: ' + decrypted_text
