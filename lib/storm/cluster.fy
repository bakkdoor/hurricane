class Storm {
  class Cluster {
    def submit_topology: tup with_config: conf (nil) {}
  }

  class LocalCluster : Cluster
  class RemoteCluster : Cluster
}