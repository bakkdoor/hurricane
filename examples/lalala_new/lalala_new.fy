require: "storm"

lalala = Storm Topology new: "lalala" with: {
  RandomWordSpout = spout: {
    streams: {
      words: { name }
    }
    parallelism: 10
    initialize: |words| {
      @words = words
    }
    process: {
      words <- (@words random) true # acked
    }
  }

  LalalaBolt = bolt: {
    streams: { lalala_words }
    parallelism: 3
    RandomWordSpout words: { name } . process: |tuple| {
     lalala_words <- (tuple[0] + "lalala") true
    }
  }
}

lalala run_with: {
  RandomWordSpout -> {
    initialize: ("chris", "mike", "nathan")
  }
  LalalaBolt -> {}
}

Storm local_cluster submit_topology: lalala