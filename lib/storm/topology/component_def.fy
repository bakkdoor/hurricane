class Storm Topology {
  class ComponentDef {
    read_write_slots: ('topology, 'parallelism)

    def initialize
    def initialize: block {
      initialize
      block call: [self]
    }

    def to_thrift {
      "Not implemented" raise!
    }
  }
}