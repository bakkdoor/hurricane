# Twitter Reach sample topology
# Translated from the storm-starter project
# See:
# https://github.com/nathanmarz/storm-starter/blob/master/src/jvm/storm/starter/ReachTopology.java

require: "get_followers"
require: "get_tweeters"
require: "partial_uniquer"
require: "count_aggregator"

class Reach : Storm LinearDRPCTopology {
  setup: {
    GetTweeters -- shuffle --> GetFollowers -- { id follower } --> PartialUniquer -- { id } --> CountAggregator

    GetTweeters     * 3
    GetFollowers    * 12
    PartialUniquer  * 6
    CountAggregator * 2
  }
}

conf = Storm Config new: {
  max_task_parallelism: 2
}

if: (ARGV size == 0) then: {
  conf max_task_parallelism: 3
  drpc = Storm LocalDRPC new
  reach drpc: drpc
  Storm local_cluster submit_topology: reach with_config: conf

  ["foo.com/blog/1", "engineering.twitter.com/blog/5", "notaurl.com"] each: |url| {
    "Reach of: #{url}:" print
    drpc execute: "reach" with_params: [url] . println
  }
} else: {
  conf num_workers: 6
  reach name: $ ARGV[0]
  Storm remote_cluster submit_topology: reach with_config: conf
}