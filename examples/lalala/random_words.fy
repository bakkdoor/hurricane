class RandomWords : Storm Spout {
  output: { word }
  slots:  { words }

  def next_tuple {
    emit: $ @words random
  }
}