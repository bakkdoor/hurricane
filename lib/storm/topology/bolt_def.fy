class Storm {
  class Topology {
    class BoltDef : ComponentDef {
      read_write_slots: ('bolt, 'grouping)
      def initialize: topology with: block {
        initialize: topology
        @grouping = Grouping none
        @bolt = block call_with_receiver: self
      }

      def groups_on_fields: fields from: id (nil) {
        { id = id id } if: (id is_a?: ComponentDef)
        @grouping = Grouping fields: fields from: id
      }

      def shuffle_grouping {
        @grouping = Grouping shuffle
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

      def to_thrift {
        (0, nil) # TODO
      }
    }
  }
}