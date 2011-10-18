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
  }
}