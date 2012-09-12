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
}