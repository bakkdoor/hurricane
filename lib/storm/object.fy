class Object {
  def bolt: block {
    b = Storm Bolt new
    block call: [b]
    b
  }

  def spout: block {
    s = Storm Spout new
    block call: [s]
    s
  }
}