require: "stormi.fy"

FancySpec describe: Storm Topology with: {
  it: "creates an empty topology" when: {
    t = Storm Topology new: "test" with: {}
    t bolts empty? is: true
    t spouts empty? is: true
    t name is: "test"
  }

  it: "creates a topology with 1 spout" when: {
    t = Storm Topology new: "test1" with: {
      spout: {
        parallelism: 10
        Storm Spout new
      }
    }
    t bolts empty? is: true
    t spouts empty? is: false
    t spouts size is: 1
    t spouts first parallelism is: 10
  }

  it: "creates a topology with 2 bolt" when: {
    t = Storm Topology new: "test2" with: {
      bolt: {
        parallelism: 2
        Storm Bolt new
      }
    }
    t bolts empty? is: false
    t spouts empty? is: true
    t bolts size is: 1
    t bolts first parallelism is: 2
  }

  it: "creates a topology with multiple bolts and spouts" when: {
    class MultipleOutputStreamsSpout : Storm Spout {
      output_streams: {
        @stream1 = stream: {
          fields: ["f1", "f2"]
          direct: true
        }
        @stream2 = stream: {
          fields: ["f3", "f4", "f5"]
        }
      }
    }

    t = Storm Topology new: "test3" with: {
      @s1 = spout: {
        Storm Spout new
      }
      @s2 = spout: {
        parallelism: 5
        Storm Spout new
      }
      @s3 = spout: {
        MultipleOutputStreamsSpout new
      }

      @b1 = bolt: {
        parallelism: 2
        groups_on_fields: ["field1", "field2"] from: @s1
        groups_on_fields: ["field3"] from: @s2
        Storm Bolt new
      }

      @b2 = bolt: {
        parallelism: 10
        subscribes_to: 'stream1 grouped_on: ["f2"] from: @s3
        subscribes_to: 'stream2 grouped_on: ["f3", "f5"] from: @s3
      }
    }
    t bolts empty? is: false
    t spouts empty? is: false
    t bolts size is: 2
    t spouts size is: 3

    t s1 parallelism is: 1
    t s2 parallelism is: 5
    t s3 parallelism is: 1

    t s3 spout output_streams size is: 2

    t b1 parallelism is: 2
    t b2 parallelism is: 10
  }
}
