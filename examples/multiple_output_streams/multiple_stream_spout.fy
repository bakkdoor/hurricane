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

  outputs: {
    people: { name age }
    cities: { name country direct: true }
  }

  def next_tuple {
    people: $ People random
    cities: $ Cities random
  }
}