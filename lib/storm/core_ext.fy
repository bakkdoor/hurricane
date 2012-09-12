class Block {
  lazy_slot: 'block_bolt value: { Storm BlockBolt new: self }

  def --> component {
    block_bolt --> component
  }

  def -- grouping {
    block_bolt -- grouping
  }
}