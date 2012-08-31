class RandomWords : Storm Spout {
  output: { name }
  slots:  { words }

  def next_tuple {
    @words random
  }
}