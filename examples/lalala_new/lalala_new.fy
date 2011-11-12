require: "storm"

RandomWordSpout = spout: {
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
    # do something in here if necessary (optional)
  # }
  # process: defines the code for emitting & processing tuples
  process: {
    # refer to streams by their name.
    # in this case we just use the default stream:
    default <- (@words random) true # acked
  }
}

LalalaBolt = bolt: {
  fields: { lalala_name }
  slots: { random_words }
  # if there are multiple output streams use this:
  # RandomWordSpout names: { name } . process: |tuple| {
  # in our case we just group on the default stream's fields directly:
  @random_words grouped: { name } . process: |tuple| {
    default <- (tuple[0] + "lalala") true
  }
}

lalala = Storm Topology new: "lalala" with: @{
  spouts: {
    # use names instead of numbers for components:
    random_words: $ RandomWordSpout new: [("chris", "mike", "nathan")] . with: { parallelism: 10 }
  }
  bolts: {
    # refer to other components via their name:
    lalala: $ LalalaBolt new: [random_words] . with: @{ parallelism: 3 }
  }
}

Storm local_cluster submit_topology: lalala