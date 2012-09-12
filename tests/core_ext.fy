require: "../lib/storm"

FancySpec describe: Block with: {
  it: "lazily returns a BlockBolt for itself" with: 'block_bolt when: {
    b = @{ + 2 }
    bb = b block_bolt
    bb is_a: Storm BlockBolt
    bb block is: b
    b block_bolt is: bb # returns same instance (cached)
  }
}