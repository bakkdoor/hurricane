require: "../lib/storm"

FancySpec describe: Storm Topology with: {
  it: "creates an empty topology" when: {
    class TestTop : Storm Topology
    TestTop new do: @{
      bolts empty? is: true
      spouts empty? is: true
      name is: "test_top"
    }
  }

  it: "creates a topology with 1 spout" when: {
    class Spout1 : Storm Spout
    class Topology1 : Storm Topology {
      setup: {
        Spout1 * 10
      }
    }

    Topology1 new do: @{
      bolts empty? is: true
      spouts empty? is: false
      spouts size is: 1
      spouts first parallelism is: 10
    }
  }

  it: "creates a topology with 2 bolt" when: {
    class Bolt2 : Storm Bolt
    class Topology2 : Storm Topology {
      setup: {
        Bolt2 * 2
      }
    }

    Topology2 new do: @{
      bolts empty? is: false
      spouts empty? is: true
      bolts size is: 1
      bolts first parallelism is: 2
    }
  }

  it: "creates a topology with multiple bolts and spouts" when: {
    class MultipleOutputStreamsSpout : Storm Spout {
      outputs: {
        stream1: { f1 f2 direct: true }
        stream2: { f3 f4 f5 }
      }
    }
    class Spout1 : Storm Spout
    class Spout2 : Storm Spout
    class Bolt1 : Storm Bolt
    class Bolt2 : Storm Bolt

    class Topology3 : Storm Topology {
      setup: {
        Spout1 -- { field1 field2 } --> Bolt1
        Spout2 -- { field3 } --> Bolt1

        MultipleOutputStreamsSpout -- { stream1: { f2 } stream2: { f3 f5 } } --> Bolt2


        Spout1 * 1
        Spout2 * 5
        MultipleOutputStreamsSpout * 2
        Bolt1 * 2
        Bolt2 * 10
      }
    }

    Topology3 new do: |t| {
      t bolts empty? is: false
      t spouts empty? is: false
      t bolts size is: 2
      t spouts size is: 3

      Spout1 parallelism is: 1
      Spout2 parallelism is: 5
      MultipleOutputStreamsSpout parallelism is: 2

      MultipleOutputStreamsSpout output_streams size is: 2

      Bolt1 parallelism is: 2
      Bolt2 parallelism is: 10
    }
  }
}
