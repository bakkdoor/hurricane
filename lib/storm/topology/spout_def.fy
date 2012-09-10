class Storm Topology {
  class SpoutDef : ComponentDef {
    read_write_slot: 'spout

    def to_thrift {
      shellcmd = ShellComponent new(<['execution_command => "/usr/bin/env fancy", 'script => nil]>)
      spout_obj = ComponentObject shell(shellcmd)
      streams = <[]>

      @spout class output_streams each: |s| {
        streaminfo = StreamInfo new(<['output_fields => s fields, 'direct => s direct]>)
        streams[s id]: streaminfo
      }

      common = ComponentCommon new(<['streams => streams, 'parallelism_hint => @parallelism]>)
      spout_spec = SpoutSpec new(<['spout_object => spout_obj, 'common => common, 'distributed => true]>)
      (spout component_name, spout_spec)
    }
  }
}