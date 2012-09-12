require: "../lib/storm"

Grouping = Storm Grouping
NoneGrouping = Storm NoneGrouping
ShuffleGrouping = Storm ShuffleGrouping
FieldsGrouping = Storm FieldsGrouping
MultiGrouping = Storm MultiGrouping

FancySpec describe: Grouping with: {
  def parse_grouping: grouping {
    Grouping parse: grouping sender: nil receiver: nil
  }

  it: "parses a grouping correctly" when: {
    parse_grouping: { none } . is_a: NoneGrouping
    parse_grouping: { shuffle } . is_a: ShuffleGrouping
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

    MySpout[0] -- { shuffle } --> MyBolt[0]

    Storm Grouping[MySpout[0]] size is: 1
  }
}