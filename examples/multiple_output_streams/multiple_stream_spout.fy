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
    stream: {
      fields: ('name, 'age)
      name: 'person_stream
    }
    stream: {
      fields: ('name, 'country)
      direct: true  # optional, defaults to false
      name: 'city_stream
    }
  }

  def run {
    loop: {
      on: 'person_stream emit: $ People random
      on: 'city_stream emit: $ Cities random
    }
  }
}

if: (ARGV main?: __FILE__) then: {
  MultipleStreamSpout new run
}