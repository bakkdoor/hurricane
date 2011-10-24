class GetFollowers : Storm Bolt {
  FOLLOWERS_DB = <[
    "sally" => ["bob", "tim", "alice", "adam", "jim", "chris", "jai"],
    "bob" => ["sally", "nathan", "jim", "mary", "david", "vivian"],
    "tim" => ["alex"],
    "nathan" => ["sally", "bob", "adam", "harry", "chris", "vivian", "emily", "jordan"],
    "adam" => ["david", "carissa"],
    "mike" => ["john", "bob"],
    "john" => ["alice", "nathan", "jim", "mike", "bob"]
  ]>

  output_fields: ("id", "follower")

  def process: tuple {
    id, tweeter = tuple
    followers = FOLLOWERS_DB[tweeter]
    if: followers then: {
      followers each: |f| {
        emit: (id, f)
      }
    }
  }
}

if: (ARGV main?: __FILE__) then: {
  GetFollowers new run
}