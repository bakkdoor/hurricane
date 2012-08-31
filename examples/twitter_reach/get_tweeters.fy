class GetTweeters : Storm Bolt {
  TWEETERS_DB = <[
    "foo.com/blog/1" => ["sally", "bob", "tim", "george", "nathan"],
    "engineering.twitter.com/blog/5" => ["adam", "david", "sally", "nathan"],
    "tech.backtype.com/blog/123" => ["tim", "mike", "john"]
  ]>

  input:  { id url }
  output: { id tweeter }
  ack_on_success: true

  def process {
    tweeters =
    if: (TWEETERS_DB[url]) then: @{
      each: |t| {
        output: (id, t)
      }
    }
  }
}