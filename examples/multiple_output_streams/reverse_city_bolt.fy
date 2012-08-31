class ReverseCityBolt : Storm Bolt {
  input:  { name }
  output: { reversed_name } # just 1 output field

  ack_on_success: true
  anchor_tuples:  true

  def process {
    output: $ name reverse
  }
}