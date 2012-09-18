class PartialUniquer : Storm BatchBolt {
  input:  { id follower }
  output: { id partial_count }
  slots:  { followers: { Set new } }

  def process {
    @followers << follower
  }

  def finished_batch {
    output: (batch_id, @followers size)
  }
}