**TODO: Add description**

## Installation
Technologies:
Elixir
Docker
Redis
Kafka

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `cermicros` to your list of dependencies in `mix.exs`:
in root directory:
mix do deps.get, compile
iex -S mix

iex -S mix

12:07:12.000 [debug] event#start=Elixir.Kaffe

12:07:12.001 [debug] event#start_producer_client=Elixir.Kaffe

12:07:12.011 [notice]     :supervisor: {:local, :brod_sup}
    :started: [
  pid: #PID<0.285.0>,
  id: :kaffe_producer_client,
  mfargs: {:brod_client, :start_link,
   [
     [{~c"localhost", 9093}],
     :kaffe_producer_client,
     [
       auto_start_producers: true,
       allow_topic_auto_creation: false,
       default_producer_config: [
         required_acks: -1,
         ack_timeout: 1000,
         partition_buffer_limit: 512,
         partition_onwire_limit: 1,
         max_batch_size: 1048576,
         max_retries: 3,
         retry_backoff_ms: 500,
         compression: :no_compression,
         min_compression_batch_size: 1024
       ]
     ]
   ]},
  restart_type: {:permanent, 10},
  shutdown: 5000,
  child_type: :worker
]

12:07:12.109 [info] TaskManager init.

12:07:12.110 [info] Init scheduling: run schedule_work().

12:07:12.114 [info] PageProducer init.

12:07:12.123 [info] Cermicros.PageConsumerSupervisor init.

12:07:12.124 [info] PageProducer received demand for 500 pages.

12:07:12.126 [info] Cermicros.Microservice init.

12:07:12.158 [info] Plug now running on localhost:4000

12:08:12.161 [info] #PID<0.442.0> WorkConsumer received domain: bitget.com, urls count: 1

12:08:12.161 [info] #PID<0.443.0> WorkConsumer received domain: bitmake.com, urls count: 1

12:08:12.161 [info] #PID<0.446.0> WorkConsumer received domain: cex.io, urls count: 1

12:08:12.161 [info] #PID<0.444.0> WorkConsumer received domain: bitstamp.net, urls count: 2

12:08:12.161 [info] #PID<0.447.0> WorkConsumer received domain: crypto.com, urls count: 1

12:08:12.161 [info] #PID<0.445.0> WorkConsumer received domain: bybit.com, urls count: 1

12:08:12.161 [info] #PID<0.448.0> WorkConsumer received domain: digifinex.com, urls count: 1

12:08:12.161 [info] #PID<0.449.0> WorkConsumer received domain: gateio.ws, urls count: 1

12:08:12.161 [info] #PID<0.450.0> WorkConsumer received domain: gemini.com, urls count: 9

12:08:12.161 [info] #PID<0.440.0> WorkConsumer received domain: bitfinex.com, urls count: 44

12:08:12.161 [info] #PID<0.441.0> WorkConsumer received domain: bitforex.com, urls count: 1

12:08:12.161 [info] #PID<0.453.0> WorkConsumer received domain: poloniex.com, urls count: 1

12:08:12.161 [info] #PID<0.452.0> WorkConsumer received domain: kraken.com, urls count: 1

12:08:12.161 [info] #PID<0.454.0> WorkConsumer received domain: probit.com, urls count: 1

12:08:12.161 [info] #PID<0.455.0> WorkConsumer received domain: whitebit.com, urls count: 1

12:08:12.161 [info] #PID<0.451.0> WorkConsumer received domain: huobi.pro, urls count: 1

12:08:12.161 [info] #PID<0.439.0> WorkConsumer received domain: binance.com, urls count: 1
time 0.588s, domain: bitstamp.net, url count: 2
time 0.621s, domain: cex.io, url count: 1

12:08:12.791 [debug] event#produce topic=exchange_topic key=exchange_topic partitions_count=1 selected_partition=0

12:08:12.792 [debug] event#produce topic=exchange_topic key=exchange_topic partitions_count=1 selected_partition=0

12:08:12.792 [notice]     :supervisor: {#PID<0.300.0>, :brod_producers_sup}
    :started: [
  pid: #PID<0.736.0>,
  id: "exchange_topic",
  mfargs: {:brod_supervisor3, :start_link,
   [
     :brod_producers_sup,
     {:brod_producers_sup2, #PID<0.285.0>, "exchange_topic",
      [
        required_acks: -1,
        ack_timeout: 1000,
        partition_buffer_limit: 512,
        partition_onwire_limit: 1,
        max_batch_size: 1048576,
        max_retries: 3,
        retry_backoff_ms: 500,
        compression: :no_compression,
        min_compression_batch_size: 1024
      ]}
   ]},
  restart_type: {:permanent, 10},
  shutdown: :infinity,
  child_type: :supervisor
]

12:08:12.812 [notice]     :supervisor: {#PID<0.736.0>, :brod_producers_sup}
    :started: [
  pid: #PID<0.737.0>,
  id: 0,
  mfargs: {:brod_producer, :start_link,
   [
     #PID<0.285.0>,
     "exchange_topic",
     0,
     [
       required_acks: -1,
       ack_timeout: 1000,
       partition_buffer_limit: 512,
       partition_onwire_limit: 1,
       max_batch_size: 1048576,
       max_retries: 3,
       retry_backoff_ms: 500,
       compression: :no_compression,
       min_compression_batch_size: 1024
     ]
   ]},
  restart_type: {:permanent, 5},
  shutdown: 5000,
  child_type: :worker
]

12:08:12.824 [info] client :kaffe_producer_client connected to localhost:9093

time 0.689s, domain: whitebit.com, url count: 1

12:08:12.852 [debug] event#produce topic=exchange_topic key=exchange_topic partitions_count=1 selected_partition=0
time 0.694s, domain: kraken.com, url count: 1

12:08:12.856 [debug] event#produce topic=exchange_topic key=exchange_topic partitions_count=1 selected_partition=0
time 0.701s, domain: bitfinex.com, url count: 44

12:08:12.868 [debug] event#produce topic=exchange_topic key=exchange_topic partitions_count=1 selected_partition=0
time 0.788s, domain: digifinex.com, url count: 1

12:08:12.950 [debug] event#produce topic=exchange_topic key=exchange_topic partitions_count=1 selected_partition=0
time 0.808s, domain: binance.com, url count: 1

12:08:12.972 [debug] event#produce topic=exchange_topic key=exchange_topic partitions_count=1 selected_partition=0
time 0.813s, domain: huobi.pro, url count: 1

12:08:12.977 [debug] event#produce topic=exchange_topic key=exchange_topic partitions_count=1 selected_partition=0
time 0.822s, domain: bitforex.com, url count: 1
time 0.826s, domain: bybit.com, url count: 1

12:08:12.987 [debug] event#produce topic=exchange_topic key=exchange_topic partitions_count=1 selected_partition=0

12:08:12.988 [debug] event#produce topic=exchange_topic key=exchange_topic partitions_count=1 selected_partition=0
time 0.831s, domain: bitget.com, url count: 1

12:08:12.994 [debug] event#produce topic=exchange_topic key=exchange_topic partitions_count=1 selected_partition=0
time 0.853s, domain: poloniex.com, url count: 1

12:08:13.018 [debug] event#produce topic=exchange_topic key=exchange_topic partitions_count=1 selected_partition=0
time 0.901s, domain: crypto.com, url count: 1

12:08:13.066 [debug] event#produce topic=exchange_topic key=exchange_topic partitions_count=1 selected_partition=0
time 0.942s, domain: gemini.com, url count: 9

12:08:13.104 [debug] event#produce topic=exchange_topic key=exchange_topic partitions_count=1 selected_partition=0
time 1.502s, domain: gateio.ws, url count: 1

12:08:13.664 [debug] event#produce topic=exchange_topic key=exchange_topic partitions_count=1 selected_partition=0
time 1.751s, domain: bitmake.com, url count: 1

12:08:13.914 [debug] event#produce topic=exchange_topic key=exchange_topic partitions_count=1 selected_partition=0
time 1.861s, domain: probit.com, url count: 1

12:08:14.031 [debug] event#produce topic=exchange_topic key=exchange_topic partitions_count=1 selected_partition=0

