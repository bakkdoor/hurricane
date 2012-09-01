require: "multiple_stream_spout"
require: "reverse_person_bolt"
require: "reverse_city_bolt"

class PeopleAndCities : Storm Topology {
  MultipleStreamSpout -- [
    { city_stream: { name } } --> ReverseCityBolt,
    { person_stream: {} }     --> ReversePersonBolt
  ]

  MultipleStreamSpout * 10
  ReverseCityBolt     * 3
  ReversePersonBolt   * 3
}