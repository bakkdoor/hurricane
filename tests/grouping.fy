require: "../lib/storm"

Grouping = Storm Grouping
NoneGrouping = Storm NoneGrouping
ShuffleGrouping = Storm ShuffleGrouping
FieldsGrouping = Storm FieldsGrouping
MultiGrouping = Storm MultiGrouping

FancySpec describe: Grouping with: {
  def parse_grouping: grouping {
    Grouping parse: grouping
  }

  it: "parses a grouping correctly" when: {
    parse_grouping: (NoneGrouping new) . is_a: NoneGrouping
    parse_grouping: (ShuffleGrouping new) . is_a: ShuffleGrouping
    parse_grouping: { foo bar baz } . is_a: FieldsGrouping
    parse_grouping: { stream1: { foo bar baz } stream2: { bar baz bazinga } } . is_a: MultiGrouping
  }

  it: "keeps track of the right groupings for component streams" when: {
    class MyBolt : Storm Bolt {
      output: { a b c}
    }
    class MySpout : Storm Spout {
      output: { a b c }
    }

    Storm Topology Definition new do:
    {
      MySpout[0] -- none --> (MyBolt[0])
      MySpout[0] -- shuffle --> (MyBolt[1])
      MySpout[1] -- { a b } --> (MyBolt[0])
    }

    groupings = Grouping[MySpout[0]]
    groupings size is: 2
    groupings first is_a: NoneGrouping
    groupings first receiver is: $ MyBolt[0]
    groupings second is_a: ShuffleGrouping
    groupings second receiver is: $ MyBolt[1]

    groupings = Grouping[MySpout[1]]
    groupings size is: 1
    groupings first is_a: FieldsGrouping
    groupings first receiver is: $ MyBolt[0]
  }
}