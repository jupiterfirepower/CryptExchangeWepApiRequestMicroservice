import Config

config :cermicros, Cermicros.Cache,
conn_opts: [
         host: "host.docker.internal",
         port: 6379,
         # Add the password if 'requirepass' is on
         password: "sOmE_sEcUrE_pAsS"
       ]

config :kaffe,
       producer: [
         endpoints: ["host.docker.internal": 9093],
         # endpoints references [hostname: port]. Kafka is configured to run on port 9092.
         # In this example, the hostname is localhost because we've started the Kafka server
         # straight from our machine. However, if the server is dockerized, the hostname will
         # be called whatever is specified by that container (usually "kafka")
         topics: ["exchange_topic"], # add a list of topics you plan to produce messages to
       ]

#environment :docker do
#    set dev_mode: false
#    set include_erts: true
#    set include_src: false
#    set cookie: :crypto.hash(:sha256, :crypto.rand_bytes(25)) |> Base.encode16 |> String.to_atom
#end

#environment :prod do
#  set dev_mode: false
#  set include_erts: true
#  set include_src: false
#  set cookie: :crypto.hash(:sha256, :crypto.rand_bytes(25)) |> Base.encode16 |> String.to_atom
#end
