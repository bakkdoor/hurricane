Fancy Package Specification new: "stormify" with: {
  author: "Christopher Bertels"
  email: "chris@fancy-lang.org"
  include_files: ["lib/stormi.fy"]
  description: "A Fancy DSL for Storm - The distributed and fault-tolerant realtime computation system used at Twitter."
  homepage: "http://www.fancy-lang.org"
  version: "0.1.0"
  dependencies: [["bakkdoor/fyzmq"]]
  ruby_dependencies: [["json", "thrift", "thrift_client"]]
}