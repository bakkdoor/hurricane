require: "../lib/storm"

Grouping = Storm Grouping
NoneGrouping = Storm NoneGrouping
ShuffleGrouping = Storm ShuffleGrouping
FieldsGrouping = Storm FieldsGrouping
MultiGrouping = Storm MultiGrouping

FancySpec describe: Grouping with: {
  it: "parses a grouping correctly" when: {
    Grouping parse: (NoneGrouping new) . is_a: NoneGrouping
    Grouping parse: (ShuffleGrouping new) . is_a: ShuffleGrouping
    Grouping parse: { foo bar baz } . is_a: FieldsGrouping
    Grouping parse: { stream1: { foo bar baz } stream2: { bar baz bazinga } } . is_a: MultiGrouping
  }

  it: "keeps track of the right groupings for component streams" when: {
    class MyBolt  : Storm Bolt
    class MySpout : Storm Spout

    Storm Topology Definition new do:
    {
      MySpout[0] --  none   --> (MyBolt[0])
      MySpout[0] -- shuffle --> (MyBolt[1])
      MySpout[1] -- { a b } --> (MyBolt[0])
      MySpout[2]            --> (MyBolt[2])
    }

    groupings = Grouping[MySpout[0]]
    groupings size is: 2
    groupings first do: @{
      is_a: NoneGrouping
      receiver is: $ MyBolt[0]
      sender is: $ MySpout[0]
    }

    groupings second do: @{
      is_a: ShuffleGrouping
      receiver is: $ MyBolt[1]
      sender is: $ MySpout[0]
    }

    groupings = Grouping[MySpout[1]]
    groupings size is: 1
    groupings first do: @{
      is_a: FieldsGrouping
      receiver is: $ MyBolt[0]
      sender is: $ MySpout[1]
    }

    groupings = Grouping[MySpout[2]]
    groupings size is: 1
    groupings first do: @{
      is_a: NoneGrouping
      receiver is: $ MyBolt[2]
      sender is: $ MySpout[2]
    }
  }
}