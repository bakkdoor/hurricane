class RandomWordSpout : Storm Spout {
  output_fields: ["name"]

  def initialize: @words

  def run {
    loop: {
      emit: [@words random]
    }
  }
}

class LalalaBolt : Storm Bolt {
  output_fields: ["lalala_name"]

  def process: tuple {
    emit: [tuple[0] + "lalala"]
  }
}

lalala = Topology new: "lalala" with: {
  spout: {
    id: 1
    parallelism: 10
    RandomWordSpout new: ["chris", "mike", "nathan"]
  }

  bolt: {
    id: 2
    parallelism: 3
    groups_on_fields: ["name"] from: 1
    LalalaBolt new
  }
}

Storm submit_topology: lalala