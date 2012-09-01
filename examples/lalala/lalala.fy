class Lalala : Storm Bolt {
  input:  { name }
  output: { lalala_name }
  ack: true # always ack

  def process {
    output: "#{name}lalala"
  }
}