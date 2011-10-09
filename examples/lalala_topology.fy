class RandomWordSpout : Storm Spout {
  output_fields: ["name"]

  def initialize: @words

  def run {
    loop: {
      emit: $ [@words random]
    }
  }
}

class LalalaBolt : Storm Bolt {
  groups_on_fields: ["name"]
  output_fields: ["lalala_name"]

  def process: tuple {
    emit: $ [tuple values first  + "lalala"]
  }
}

lalala = Topology new: "lalala" with: {
  spouts: {
    id: 1 is: $ RandomWordSpout new: ["chris", "mike", "nathan"] . do: {
      parallelism: 10
    }
  }

  bolts: {
    id: 2 is: $ LalalaBolt new do: {
      parallelism: 3
    }
  }
}

Storm submit_topology: lalala