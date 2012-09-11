require: "mocks"

class TestBolt : Storm Bolt {
  output: { comma_seperated }
  ack: true
  def process {
    output: $ @tuple join: ", "
  }
}

FancySpec describe: Storm Bolt with: {
  before_each: {
    Storm Protocol Input clear
    Storm Protocol Output clear
    @in = Storm Protocol Input
    @out = Storm Protocol Output
  }

  it: "runs as expected" for: 'run when: {
    conf = <['some_conf => false]>
    context = <['some_context => true]>
    tup1 = <['id => 1, 'comp => 2, 'stream => 3, 'task => 4, 'tuple => [1,2,3,4]]>
    task_ids_1 = <['task_ids => [1,2,3,4]]> # part of the protocol, random values though
    tup2 = <['id => 2, 'comp => 3, 'stream => 4, 'task => 5, 'tuple => ["hello", "world"]]>
    task_ids_2 = <['task_ids => [2,3,4,5]]> # same here

    handshake = <['conf => conf, 'context => context, 'pidDir => "/tmp/"]>

    @in input: [
      handshake to_json(),
      # tuples:
      tup1 to_json(), task_ids_1 to_json(),
      tup2 to_json(), task_ids_2 to_json()
    ]

    b = TestBolt new
    b run

    @out sent count: |m| {
      m includes?: $ tup1['tuple] join: ", "
    } . is: 1

    # @out sent count: |m| {
    #   m includes?: $ tup2['tuple] join: ", "
    # } . is: 1
  }
}


FancySpec describe: Storm BlockBolt with: {
  before_each: {
    Storm Protocol Input clear
    Storm Protocol Output clear
    @in = Storm Protocol Input
    @out = Storm Protocol Output
  }

  it: "runs as expected" for: 'run when: {
    conf = <['some_conf => false]>
    context = <['some_context => true]>
    tup1 = <['id => 1, 'comp => 2, 'stream => 3, 'task => 4, 'tuple => [10]]>
    task_ids_1 = <['task_ids => [1,2,3,4]]>
    tup2 = <['id => 2, 'comp => 3, 'stream => 4, 'task => 5, 'tuple => [999]]>
    task_ids_2 = <['task_ids => [2,3,4,5]]>

    handshake = <['conf => conf, 'context => context, 'pidDir => "/tmp/"]>

    @in input: [
      handshake to_json(),
      # tuples:
      tup1 to_json(), task_ids_1 to_json(),
      tup2 to_json(), task_ids_2 to_json()
    ]

    add2 = Storm BlockBolt new: @{ + 2 }
    add2 run

    @out sent count: |m| {
      m includes?: $ tup1['tuple] first + 2 to_s
    } . is: 1

    # @out sent count: |m| {
    #   m includes?: $ tup2['tuple] first + 2 to_s
    # } . is: 1
  }
}