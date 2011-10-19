require: "storm"

class RandomWordSpout : Storm Spout {
  output_fields: ["name"]
  def initialize: @words
  def run {
    loop: {
      emit: [@words random]
    }
  }
}

if: (ARGV main?: __FILE__) then: {
  RandomWordSpout new: ["chris", "mike", "nathan"] . run
}