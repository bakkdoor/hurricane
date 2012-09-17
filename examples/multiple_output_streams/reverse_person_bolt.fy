class ReversePersonBolt : Storm Bolt {
  input:  { name age }
  output: { reversed_name age }

  ack_on_success!
  anchor_tuples!

  def process {
    output: (name reverse, age)
  }
}