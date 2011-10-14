class Storm {
  class Topology {
    class ComponentDef {
      @@component_ids = 0
      def ComponentDef next_id {
        @@component_ids = @@component_ids + 1
        @@component_ids
      }
      read_write_slots: ('id, 'parallelism)
      def initialize: @topology {
        @parallelism = 1
        @id = ComponentDef next_id
      }
    }

    class BoltDef : ComponentDef {
      read_write_slots: ('bolt, 'grouping)
      def initialize: topology with: block {
        initialize: topology
        @grouping = Grouping none
        @bolt = block call_with_receiver: self
      }

      def groups_on_fields: fields from: id {
        { id = id id } if: (id is_a?: ComponentDef)
        @grouping = Grouping fields: fields from: id
      }

      def subscribes_to: stream grouped_on: fields from: bolt {
        { @grouping = MultiGrouping new } unless: (@grouping is_a?: MultiGrouping)
        if: fields then: {
          @grouping add: stream fields: fields bolt: bolt
        } else: {
          @grouping add: stream bolt: bolt
        }
      }

      def subscribes_to: stream from: bolt {
        subscribes_to: stream grouped_on: nil from: bolt
      }
    }

    class SpoutDef : ComponentDef {
      read_slot: 'spout
      def initialize: topology with: block {
        initialize: topology
        @spout = block call_with_receiver: self
      }
    }

    read_slots: ('bolts, 'spouts, 'name)

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

    # handle dynamic slot accessor messages
    def unknown_message: m with_params: p {
      if: (p empty?) then: {
        if: (m to_s =~ /^:/) then: {
          slotname = m to_s rest
          if: (get_slot: slotname) then: |slot| {
            return slot
          }
        }
      }
      super receive_message: m with_params: p
    }
  }
}