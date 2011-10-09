class Storm {
  class Topology {
    class Bolts {
      def initialize: @topology
      def id: id is: bolt {
        @topology add_bolt: bolt with_id: id
      }
    }

    class Spouts {
      def initialize: @topology
      def id: id is: spout {
        @topology add_spout: spout with_id: id
      }
    }

    def initialize: @name with: block {
      @bolts = <[]>
      @spouts = <[]>
      self do: block
    }

    def bolts: block {
      Bolts new: self . do: block
    }

    def spouts: block {
      Spouts new: self . do: block
    }

    def add_bolt: bolt with_id: id {
      @bolts[id]: bolt
    }

    def add_spout: spout with_id: id {
      @spouts[id]: spout
    }
  }
}