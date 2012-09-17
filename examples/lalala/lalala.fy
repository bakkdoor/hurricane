class Lalala : Storm Bolt {
  input:  { name }
  output: { lalala_name }
  always_ack!

  def process {
    output: "#{name}lalala"
  }
}