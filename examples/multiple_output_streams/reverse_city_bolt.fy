require: "storm"

class ReverseCityBolt : Storm Bolt {
  output_field: 'reversed_name # just 1 output field
  def process: tuple {
    emit: [tuple[0] reverse]
  }
}


if: (ARGV main?: __FILE__) then: {
  ReverseCityBolt new run
}