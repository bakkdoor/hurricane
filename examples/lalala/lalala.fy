class Lalala : Storm Bolt {
  input:  { name }
  output: { lalala_name }

  def process {
    with_ack_on_success: {
      output: "#{name}lalala"
    }
  }
}