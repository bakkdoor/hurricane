class Storm {
  def Storm local_cluster {
    LocalCluster new
  }

  def Storm remote_cluster {
    RemoteCluster new
  }

  class LocalDRPC {
    # TODO
  }
}