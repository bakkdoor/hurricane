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

class LalalaBolt : Storm Bolt {
  output_fields: ["lalala_name"]
  def process: tuple {
    emit: [tuple[0] + "lalala"]
    ack: tuple
  }
}

lalala = Storm Topology new: "lalala" with: {
  random_names = spout: {
    parallelism: 10
    RandomWordSpout new: ["chris", "mike", "nathan"]
  }

  bolt: {
    parallelism: 3
    groups_on_fields: ["name"] from: random_names
    LalalaBolt new
  }
}

Storm local_cluster submit_topology: lalala
