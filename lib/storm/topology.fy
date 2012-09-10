require: "topology/component_def"
require: "topology/bolt_def"
require: "topology/spout_def"

class Storm {
  class Topology {
    def self setup: @setup_block

    def self topology_name {
      name snake_cased
    }

    def self setup_instance {
      top = new
      if: @setup_block then: {
        let: '*storm_topology* be: top in: @setup_block
      }
      top
    }

    def initialize {
      @components = <[]>
    }


    def component: name {
      @components[name]
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