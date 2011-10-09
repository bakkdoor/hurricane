class Storm {
  class Topology {
    class ComponentDef {
      read_write_slots: ('id, 'parallelism)
      def initialize: @topology {
        @parallelism = 1
        @id = nil
      }
    }

    class BoltDef : ComponentDef {
      read_write_slot: 'grouping
      def initialize: topology with: block {
        initialize: topology
        @grouping = Grouping none
        @bolt = block call_with_receiver: self
      }

      def groups_on_fields: fields from: id {
        @grouping = Grouping fields: fields from: id
      }
    }

    class SpoutDef : ComponentDef {
      def initialize: topology with: block {
        initialize: topology
        @spout = block call_with_receiver: self
      }
    }

    def initialize: @name with: block {
      @bolts = []
      @spouts = []
      self do: block
    }

    def bolt: block {
      b = BoltDef new: self with: block
      @bolts << b
    }

    def spout: block {
      s = SpoutDef new: self with: block
      @spouts << s
    }
  }
}