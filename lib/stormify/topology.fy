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
        { id = id id } if: (id is_a?: ComponentDef)
        @grouping = Grouping fields: fields from: id
      }

      def subscribe_to: stream grouped_on: fields from: bolt {
        { @grouping = MultiGrouping new } unless: (@grouping is_a?: MultiGrouping)
        @grouping add: stream fields: fields bolt: bolt
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
      b
    }

    def spout: block {
      s = SpoutDef new: self with: block
      @spouts << s
      s
    }
  }
}