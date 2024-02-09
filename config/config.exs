import Config

config :cermicros, Cermicros.Cache,
conn_opts: [
         host: "127.0.0.1",
         port: 6379,
         # Add the password if 'requirepass' is on
         password: "sOmE_sEcUrE_pAsS"
       ]

config :kaffe,
       producer: [
         endpoints: [localhost: 9093],
         # endpoints references [hostname: port]. Kafka is configured to run on port 9092.
         # In this example, the hostname is localhost because we've started the Kafka server
         # straight from our machine. However, if the server is dockerized, the hostname will
         # be called whatever is specified by that container (usually "kafka")
         topics: ["exchange_topic"], # add a list of topics you plan to produce messages to
       ]
