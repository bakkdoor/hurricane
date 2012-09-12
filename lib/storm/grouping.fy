class Storm {
  class Grouping {
    class ClassMethods {
      lazy_slot: 'groupings value: { <[]> }

      def [component] {
        groupings at: component else_put: { [] }
      }

      def parse: grouping_data sender: sender (nil) receiver: receiver (nil) {
        if: (grouping_data is_a?: Grouping) then: {
          return grouping_data tap: @{ sender: sender; receiver: receiver }
        }

        fields_arr = grouping_data to_a
        match fields_arr {
          case _ ->
            if: (fields_arr first is_a?: Array) then: {
              hash = grouping_data to_hash
              groupings = hash map: |stream fields| {
                g = Grouping parse: fields sender: sender receiver: receiver
                g stream: stream
                g
              }
              return MultiGrouping new: sender to: receiver groupings: groupings
            }
            return FieldsGrouping new: sender to: receiver fields: fields_arr
         }
      }
    }

    extend: ClassMethods
    read_write_slots: ('sender, 'receiver)
    def initialize: @sender to: @receiver

    def --> component {
      receiver: component
      component
    }
  }

  class NoneGrouping : Grouping

  class ShuffleGrouping : Grouping

  class FieldsGrouping : Grouping {
    read_write_slots: ('fields, 'stream)
    def initialize: @sender to: @receiver fields: @fields stream: @stream ('output);
  }

  class MultiGrouping : Grouping {
    read_write_slot: 'groupings
    def initialize: @sender to: @receiver groupings: @groupings ([]);
  }
}