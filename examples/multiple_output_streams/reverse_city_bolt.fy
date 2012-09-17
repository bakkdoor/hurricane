class ReverseCityBolt : Storm Bolt {
  input:  { name }
  output: { reversed_name } # just 1 output field

  ack_on_success!
  anchor_tuples!

  def process {
    output: $ name reverse
  }
}