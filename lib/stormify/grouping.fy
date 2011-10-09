class Storm {
  class Grouping {
    def Grouping none {
      NoneGrouping new
    }

    def Grouping fields: fields {
      FieldsGrouping new: fields
    }
  }

  class NoneGrouping : Grouping {
  }

  class FieldsGrouping : Grouping {
    read_slot: 'fields
    def initialize: @fields
  }
}