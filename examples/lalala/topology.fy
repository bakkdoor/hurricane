require: "random_words"
require: "lalala"

class LalalaTopology : Storm Topology {
  setup: {
    RandomWords --> { name } ---> Lalala

    RandomWords config: @{
      setup: @{ names: ["chris", "mike", "nathan"] }
      parallelism: 10
    }
    Lalala config: @{ parallelism: 3 }
  }
}

Storm local_cluster submit_topology: LalalaTopology