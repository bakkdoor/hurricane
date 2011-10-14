class Storm {
  class Cluster {
    def submit_topology: tup
  }

  class LocalCluster : Cluster
  class RemoteCluster : Cluster
}