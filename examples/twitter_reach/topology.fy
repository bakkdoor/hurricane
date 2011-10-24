# Twitter Reach sample topology
# Translated from the storm-starter project
# See:
# https://github.com/nathanmarz/storm-starter/blob/master/src/jvm/storm/starter/ReachTopology.java

require: "storm"

require: "get_followers"
require: "get_tweeters"
require: "partial_uniquer"
require: "count_aggregator"

reach = Storm LinearDRPCTopology new: "reach" with: {
  bolt: {
    parallelism: 3
    GetTweeters
  }

  bolt: {
    parallelism: 12
    shuffle_grouping
    GetFollowers
  }

  bolt: {
    parallelism: 6
    groups_on_fields: ("id", "follower")
    PartialUniquer
  }

  bolt: {
    parallelism: 2
    groups_on_fields: ["id"]
    CountAggregator
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