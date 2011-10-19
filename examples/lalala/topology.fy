require: "storm"
require: "random_word_spout"
require: "lalala_bolt"

lalala = Storm Topology new: "lalala" with: {
  random_names = spout: {
    parallelism: 10
    RandomWordSpout
  }

  bolt: {
    parallelism: 3
    groups_on_fields: ["name"] from: random_names
    LalalaBolt
  }
}

Storm local_cluster submit_topology: lalala
