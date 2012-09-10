class Storm Topology {
  class BoltDef : ComponentDef {
    read_write_slots: ('bolt, 'groupings)

    def initialize {
      @groupings = Set new
    }

    def add_grouping: grouping {
      @groupings << grouping
    }
  }
}