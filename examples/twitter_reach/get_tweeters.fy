class GetTweeters : Storm Bolt {
  TWEETERS_DB = <[
    "foo.com/blog/1" => ["sally", "bob", "tim", "george", "nathan"],
    "engineering.twitter.com/blog/5" => ["adam", "david", "sally", "nathan"],
    "tech.backtype.com/blog/123" => ["tim", "mike", "john"]
  ]>

  ouput_fields: ("id", "tweeter")

  def process: tuple {
    id, url = tuple
    tweeters = TWEETERS_DB[url]
    if: tweeters then: {
      tweeters each: |t| {
        emit: (id, t)
      }
    }
  }
}