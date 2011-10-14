require: "storm"

class MultipleStreamSpout : Storm Spout {
  Cities =
    (("Berlin", "Germany"),
     ("New York", "United States"),
     ("Paris", "France"),
     ("London", "England"),
     ("Barcelona", "Spain"),
     ("Rome", "Italy"))

  People =
    (("Adam", 30),
     ("Julie", 25),
     ("Mark", 35),
     ("Jack", 20),
     ("Cindy", 40))

  output_streams: {
    @person_stream = stream: {
      fields: ('name, 'age)
    }
    @city_stream = stream: {
      fields: ('name, 'country)
      direct: true  # optional, defaults to false
    }
  }

  def run {
    loop: {
      @city_stream emit: $ Cities random
      @person_stream emit: $ People random
    }
  }
}

class ReversePersonBolt : Storm Bolt {
  output_fields: ('reversed_name, 'age)
  def process: tuple {
    emit: (tuple[0] reverse, tuple[1])
    ack: tuple
  }
}

class ReverseCityBolt : Storm Bolt {
  output_field: 'reversed_name # just 1 output field
  def process: tuple {
    emit: [tuple[0] reverse]
  }
}

t = Storm Topology new: "persons and cities" with: {
  persons_and_cities = spout: {
    parallelism: 10
    MultipleStreamSpout new
  }

  bolt: {
    parallelism: 5
    subscribes_to: 'city_stream grouped_on: ['name] from: persons_and_cities
    ReverseCityBolt new
  }

  bolt: {
    parallelism: 5
    subscribes_to: 'person_stream from: persons_and_cities # no explicit grouping for this bolt
    ReversePersonBolt new
  }
}