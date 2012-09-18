# Hurricane
## Fancy DSL for Storm - The distributed and fault-tolerant realtime computation system used at Twitter

Hurricane is a Fancy DSL and library for writing Storm Topologies (including bolts, spouts and topology definitions) completely in Fancy.

It even has support for using standard Fancy Blocks (closures / anonymous functions) as bolts our spouts.

Here's the DoubleAndTripleBolt from [Storm's wiki](https://github.com/nathanmarz/storm/wiki/Tutorial) implemented with Hurricane:

```fancy
class DoubleAndTripleBolt : Storm Bolt {
  input:  { value }
  output: { double tripple }
  ack_on_success!

  def process {
    output: (value * 2, value * 3)
  }
}
```

Here's the ExclamationBolt:

```fancy
class ExclamationBolt : Storm Bolt {
  input:  { word }
  output: { exclamation_word }
  ack_on_success!
  anchor_tuples!

  def process {
    output: "#{word}!!!"
  }
}
```

Here's the ExclamationBolt as a BlockBolt using a partial Block:

```fancy
ExclamationBolt = BlockBolt new: @{ ++ "!!!" }
```

Have a look at the examples/ directory for more complete examples of Storm Topologies written with Hurricane.