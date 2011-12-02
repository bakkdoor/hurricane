*storm_definition*
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
}