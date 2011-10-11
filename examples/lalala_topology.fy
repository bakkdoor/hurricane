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

  output_streams: {
    url = stream: {
      fields: ["foo", "bar"]
      direct: true  # optional, defaults to false
    }
    foo = stream: {
      fields: ["bar", "baz"]
      direct: false # optional, defaults to false
    }
  }

  def process: tuple {
    emit: [tuple[0] + "lalala"]
  }
}

lalala = Storm Topology new: "lalala" with: {
  random_names = spout: {
    parallelism: 10
    RandomWordSpout new: ["chris", "mike", "nathan"]
  }

  bolt: {
    parallelism: 3
    groups_on_fields: ["name"] from: random_names # alternatively just use 1 (the spout's id) here.
    subscribe_to: 'url grouped_on: ["name"] from: random_names
    LalalaBolt new
  }
}

Storm submit_topology: lalala