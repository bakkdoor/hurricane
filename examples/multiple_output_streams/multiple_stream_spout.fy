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

if: (ARGV main?: __FILE__) then: {
  MultipleStreamSpout new run
}