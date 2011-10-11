require: "stormi.fy"

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

lalala = Storm Topology new: "lalala" with: {
  random_names = spout: {
    id: 1
    parallelism: 10
    RandomWordSpout new: ["chris", "mike", "nathan"]
  }

  lalala = bolt: {
    id: 2
    parallelism: 3
    groups_on_fields: ["name"] from: random_names # alternatively just use 1 (the spout's id) here.
    LalalaBolt new
  }
}

Storm submit_topology: lalala