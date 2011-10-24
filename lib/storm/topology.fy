require: "topology/component_def"
require: "topology/bolt_def"
require: "topology/spout_def"

class Storm {
  class Topology {
    read_slots: ('bolts, 'spouts)
    read_write_slot: 'name

    def initialize: @name with: block {
      @bolts = []
      @spouts = []
      self do: block
    }

    def bolt: block {
      b = BoltDef new: self with: block
      @bolts << b
      b
    }

    def spout: block {
      s = SpoutDef new: self with: block
      @spouts << s
      s
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
  }

  class LinearDRPCTopology : Topology
}