class Storm {
  class Bolt : Component {
    read_write_slot: 'grouping

    def initialize {
      super initialize
      @grouping = Grouping none
    }

    def groups_on_fields: fields {
      @grouping = Grouping fields: fields
    }
  }
}