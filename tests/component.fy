require: "../lib/storm"

FancySpec describe: Storm Component with: {
  class MyBolt : Storm Bolt {
    output: { a b c }
  }
  class MySpout : Storm Spout {
    output: { a b c }
  }

  it: "has the correct default component name" with: 'component_name when: {
    MyBolt new component_name is: "MyBolt"
    MyBolt["foo"] component_name is: "MyBolt:foo"
    MyBolt[123] component_name is: "MyBolt:123"

    MySpout new component_name is: "MySpout"
    MySpout[123] component_name is: "MySpout:123"
  }

  it: "has a default parallelism hint of 1" with: 'parallelism when: {
    MyBolt new parallelism is: 1
    MySpout new parallelism is: 1
  }

  it: "raises an exception if no output streams or fields are defined" when: {
    class NoStreamsBolt : Storm Bolt
    { NoStreamsBolt new } raises: Storm Component MissingOutputStreamsError
  }

  it: "raises an exception if no output streams or fields are defined" when: {
    class NoStreamsBolt : Storm Bolt {
      output: { foo bar baz }
    }
    { NoStreamsBolt new } does_not raise: Storm Component MissingOutputStreamsError
  }
}