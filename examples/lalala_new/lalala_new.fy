require: "storm"

RandomWordSpout = spout: @{
  # for multiple streams use this:
  # streams: { names: { name } }
  # for single stream (default) use this:
  fields: { name }
  # initialize takes the names of slots that should be set
  # with the passed values to #new: (see below)
  slots: { words }
  # optionally, you can also define a block of code to be run as part of initialization
  # after the slots have been assigned the passed-in values (if any), like so:
  # initialize: {
  #   # do something in here if necessary (optional)
  # }
  # process: defines the code for emitting & processing tuples
  process: {
    # refer to streams by their name.
    # in this case we just use the default stream:
    default <- (@words random)
  }
}

LalalaBolt = bolt: @{
  fields: { lalala_name }
  process: |tuple| {
    default <- (tuple[0] + "lalala") # auto-acked, call false if not acked
  }
}

lalala = Storm Topology new: "lalala" with: @{
  spouts: {
    # spout is named "random_words"
    random_words: $ RandomWordSpout new: [("chris", "mike", "nathan")] with: @{ parallelism: 10 }
  }
  bolts: {
    lalala: $ LalalaBolt new with: @{
      parallelism: 3
      # in our case we just group on the default stream's fields directly:
      fields_grouping: { name } on: 'random_words # refer to other components via their name:
    }
  }
}

Storm local_cluster submit_topology: lalala