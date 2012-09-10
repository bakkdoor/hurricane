*storm_definition* = false
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

  def Storm in_definition: block {
    let: '*storm_definition* be: true in: block
  }

  def Storm submit_topology: topology {
    remote_cluster submit_topology: topology
  }
}