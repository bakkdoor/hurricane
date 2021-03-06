require: "multiple_stream_spout"
require: "reverse_person_bolt"
require: "reverse_city_bolt"

class PeopleAndCities : Storm Topology {
  setup: {
    MultipleStreamSpout -- [
      { city_stream: { name } } --> ReverseCityBolt,
      { person_stream: none }   --> ReversePersonBolt
    ]

    MultipleStreamSpout * 10
    ReverseCityBolt     * 3
    ReversePersonBolt   * 3
  }
}

Storm submit_topology: PeopleAndCities