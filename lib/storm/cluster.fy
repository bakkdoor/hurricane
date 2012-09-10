class Storm {
  class Cluster {
    def submit_topology: topology_class with_config: conf (nil) {
      top = topology_class new
      if: *storm_definition* then: {
        "Submitting topology: #{topology_class} to cluster: #{self}" println
        submit_thrift_topology: top with_config: conf
      } else: {
        with_component: @{ run } in: top
      }
    }

    def with_component: block in: topology {
      _, _, component_name = ARGV

      unless: component_name do: {
        System abort: "No component name given. Aborting."
      }

      if: (topology component: component_name) then: block else: {
        System abort: "Invalid component specified: #{component_name inspect}"
      }
    }

    def submit_thrift_topology: top with_config: conf (nil) {
      # TODO
    }
  }

  class LocalCluster : Cluster
  class RemoteCluster : Cluster
}