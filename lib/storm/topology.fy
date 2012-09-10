class Storm {
  class Topology {
    class ClassMethods {
      def setup: @setup_block

      def topology_name {
        name snake_cased
      }

      def new {
        topology = allocate()
        topology initialize
        if: @setup_block then: {
          let: '*storm_topology* be: topology in: {
            topology do: @setup_block
          }
        }
        topology
      }

      def shuffle {
        ShuffleGrouping new
      }
    }

    extend: ClassMethods

    def initialize {
      @components = <[]>
    }

    def bolts {
      @components values select: @{ is_a?: Storm Bolt }
    }

    def spouts {
      @components values select: @{ is_a?: Storm Spout }
    }

    def component: name {
      @components[name]
    }

    def add_component: comp with_name: name (comp component_name) {
      unless: (@components includes?: name) do: {
        @components[name]: (comp new)
      }
    }

    def name {
      class topology_name
    }

    def to_thrift {
      spouts = <[]>
      bolts = <[]>
      state_spouts = <[]> # not used yet

      @spouts each: |s| {
        id, spoutspec = s to_thrift
        spouts[id]: spoutspec
      }

      @bolts each: |b| {
        id, boltspec = b to_thrift
        bolts[id]: boltspec
      }

      StormTopology new(<['spouts => spouts, 'bolts => bolts, 'state_spouts => state_spouts]>)
    }

    def to_s {
      "'#{@name}'"
    }
  }

  class LinearDRPCTopology : Topology
}