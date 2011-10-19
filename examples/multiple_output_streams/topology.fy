require: "storm"
require: "multiple_stream_spout"
require: "reverse_person_bolt"
require: "reverse_city_bolt"

t = Storm Topology new: "persons and cities" with: {
  persons_and_cities = spout: {
    parallelism: 10
    MultipleStreamSpout
  }

  bolt: {
    parallelism: 5
    subscribes_to: 'city_stream grouped_on: ['name] from: persons_and_cities
    ReverseCityBolt
  }

  bolt: {
    parallelism: 5
    subscribes_to: 'person_stream from: persons_and_cities # no explicit grouping for this bolt
    ReversePersonBolt
  }
}