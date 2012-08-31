class Block {
  def --> component {
    block_bolt --> component
  }

  def block_bolt {
    { @block_bolt = Storm BlockBolt new: self } unless: @block_bolt
    @block_bolt
  }
}