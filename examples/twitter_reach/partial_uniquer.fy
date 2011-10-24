class PartialUniquer : Storm Bolt {
  output_fields: ("id", "partial-count")
  def initialize: @sets (<[]>) {}

  def process: tuple {
    id = tuple[0]
    curr = @sets[id]
    unless: curr do: {
      curr = <[]>
      @sets[id]: curr
    }
    curr << (tuple[1])
    ack: tuple
  }

  def finished: id {
    curr = @sets delete: id
    count = 0
    { count = curr size } if: curr
    emit: (id, count)
  }
}

if: (ARGV main?: __FILE__) then: {
  PartialUniquer new run
}