class Storm {
  class Grouping {
    def Grouping none {
      NoneGrouping new
    }

    def Grouping fields: fields from: id {
      FieldsGrouping new: fields from: id
    }
  }

  class NoneGrouping : Grouping {
  }

  class FieldsGrouping : Grouping {
    read_slot: 'fields
    def initialize: @fields from: @id
  }
}