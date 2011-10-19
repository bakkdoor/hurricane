require: "storm"

class ReversePersonBolt : Storm Bolt {
  output_fields: ('reversed_name, 'age)
  def process: tuple {
    emit: (tuple[0] reverse, tuple[1])
    ack: tuple
  }
}

if: (ARGV main?: __FILE__) then: {
  ReversePersonBolt new run
}