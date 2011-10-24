class Storm {
  class Grouping {
    def Grouping none {
      NoneGrouping new
    }

    def Grouping shuffle {
      ShuffleGrouping new
    }

    def Grouping fields: fields from: id {
      FieldsGrouping new: fields from: id
    }
  }

  class NoneGrouping : Grouping {
  }

  class ShuffleGrouping : Grouping {
  }

  class FieldsGrouping : Grouping {
    read_slot: 'fields
    def initialize: @fields from: @id
  }

  class MultiGrouping {
    def initialize {
      @groupings = <[]>
    }

    def add: stream fields: fields bolt: bolt {
      @groupings[bolt]: (stream, fields)
    }

    def add: stream bolt: bolt {
      @groupings[bolt]: (stream, nil)
    }
  }
}