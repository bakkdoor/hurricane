class Storm {
  class Cluster {
    def submit_topology: top with_config: conf (nil) {
      if: *storm_definition* then: {
        "Submitting topology: #{top} to cluster: #{self}" println
        submit_thrift_topology: top with_config: conf
      } else: {
        with_component: |component, args| {
          run_component: component with_args: args
        } in: top
      }
    }

    def with_component: block in: topology {
      _, component_name, *args = ARGV
      if: (topology component: component_name) then: |comp| {
        block call: (comp, args)
      } else: {
        *stderr* println: "Invalid component specified: #{component_name inspect}"
        System exit: 1
      }
    }

    def submit_thrift_topology: top with_config: conf (nil) {
      # TODO
    }

    def run_component: comp with_args: args ([]) {
      "Component: #{comp}" println
      "Args: #{args inspect}" println
      c new: args . run
    }
  }

  class LocalCluster : Cluster
  class RemoteCluster : Cluster
}