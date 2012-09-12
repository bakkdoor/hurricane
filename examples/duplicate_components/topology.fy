class Double : Storm Bolt {
  input:  { value }
  output: { double_value }
  ack_on_success: true

  def process {
    output: (2 * value)
  }
}

# or as a Block:
Double = @{ * 2 }
Spout = @{ [1,2,3] random }
Print = @{ println }

class DuplicateComponents : Storm Topology {
  setup: {
    # assign IDs (calls to_s on ID) for multiple usage of the same component
    # in different parts of the topology:

    Spout --> (Double[1]) --> [
      (Double[2]) --> (Double[3]) --> (Print["3double"]),
      Print["1double"]
    ]

    Double[[1,2,3]]               * 3
    Print[["1double","3double"]]  * 3

    # same as:

    Double[1]         * 3
    Double[2]         * 3
    Double[3]         * 3
    Print["1double"]  * 3
    Print["3double"]  * 3
  }
}