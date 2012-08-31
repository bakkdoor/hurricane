class ReversePersonBolt : Storm Bolt {
  input:  { name age }
  output: { reversed_name age }

  ack_on_success: true
  anchor_tuples:  true

  def process {
    output: (name reverse, age)
  }
}