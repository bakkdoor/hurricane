class Storm {
  class Tuple {
    """
    Tuples are used by storm as principal data component sent between bolts and emitted by spouts.
    Contains a unique id, the component, stream and task it came from and the values associated with it.
    """

    provides_interface: 'each:
    include: Fancy Enumerable

    read_write_slots: ('id, 'component, 'stream, 'task, 'values)

    def initialize: @id component: @component stream: @stream task: @task values: @values

    def Tuple from_hash: hash {
      """
      @hash @Hash@ of values to be used for a new @Storm Tuple@.
      @return A new @Storm Tuple@ based on the values in @hash.

      Helper method to create a new tuple from a @Hash@.
      """

      id, component, stream, task, values = hash values_at: ("id", "comp", "stream", "task", "tuple")
      Tuple new: id component: component stream: stream task: task values: values
    }

    def each: block {
      @values each: block
    }
  }
}