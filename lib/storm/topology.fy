require: "topology/component_def"
require: "topology/bolt_def"
require: "topology/spout_def"

class Storm {
  class Topology {
    read_slots: ('bolts, 'spouts)
    read_write_slot: 'name

    def initialize: @name with: block {
      @components = <[]>
      @bolts = []
      @spouts = []
      block call: [self]
    }

    def bolts: block {
      @bolts = block to_hash
    }

    def spouts: block {
      @spouts = block to_hash
    }

    # handle dynamic slot accessor messages
    def unknown_message: m with_params: p {
      if: (p empty?) then: {
        if: (m to_s =~ /^:/) then: {
          slotname = m to_s rest
          if: (get_slot: slotname) then: |slot| {
            return slot
          }
        }
      }
      super receive_message: m with_params: p
    }

    def component: component_name {
      component_name = component_name to_sym
      if: (@bolts[component_name]) then: |b| {
        b
      } else: {
        @spouts[component_name]
      }
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