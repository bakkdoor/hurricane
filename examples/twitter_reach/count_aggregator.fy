class CountAggregator : Storm Bolt {
  output_fields: ("id", "reach")
  def initialize: @counts (<[]>) {}

  def process: tuple {
    id, partial = tuple
    curr = @counts[id]
    { curr = 0 } unless: curr
    @counts[id]: (curr + partial)
    ack: tuple
  }

  def finished: id {
    reach = @counts[id]
    { reach = 0 } unless: reach
    emit: (id, reach)
  }
}

if: (ARGV main?: __FILE__) then: {
  CountAggregator new run
}