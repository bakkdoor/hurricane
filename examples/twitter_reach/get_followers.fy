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

  input:  { id tweeter }
  output: { id follower }
  ack_on_success: true

  def process {
    if: (FOLLOWERS_DB[tweeter]) then: @{
      each: |f| {
        output: (id, f)
      }
    }
  }
}