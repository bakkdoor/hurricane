require: "random_words"
require: "lalala"

class LalalaTopology : Storm Topology {
  setup: {
    RandomWords -- { name } --> Lalala

    RandomWords setup: @{ names: ["chris", "mike", "nathan"] }

    RandomWords * 3
    Lalala      * 3
  }
}

Storm local_cluster submit_topology: LalalaTopology