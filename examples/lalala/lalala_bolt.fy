require: "storm"

class LalalaBolt : Storm Bolt {
  output_fields: ["lalala_name"]
  def process: tuple {
    emit: [tuple[0] + "lalala"]
    ack: tuple
  }
}

if: (ARGV main?: __FILE__) then: {
  LalalaBolt new run
}