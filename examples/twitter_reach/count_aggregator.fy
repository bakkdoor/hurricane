class CountAggregator : Storm Bolt {
  input:  { id partial }
  output: { id reach }
  slots: { counts: <[]> }
  ack_on_sucess: true


  def reach: id {
    @counts at: id else_put: { 0 }
  }

  def process {
    curr = reach: id
    @counts[id]: (curr + partial)
  }

  def finished: id {
    output: (id, reach: id)
  }
}