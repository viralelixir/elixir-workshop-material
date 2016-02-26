

## simple recursion
defmodule Recursion do
  # the public function
  def  sum_list(list) do
    sum_list(list, 0)
  end

  # internal functions
  defp sum_list([next|rest], acc) do
    sum_list(rest, acc + next)
  end

  defp sum_list([], acc) do
    acc
  end
end


# has tail call optimization, so we won't have problems with our stack
# you could do that in Ruby, but you would have problems with big lists,
# because each iteration is costing a jump in the stack



Process:
  - unit of concurrency
  - lightweight
  - almost like objects
  - messages are copied, no shared memory
  - independent garbage collection
  - they never block one each other
  - quite normal to have a high number of them, like millions
  - automatically runs on all available cores


Scheduler:
  - each process gets 2000 reductions before it is pre-empted
  -


Disributed systems:
  - up to 50 nodes you can take advantage of the OTP provided full mesh cluster communication and the
  performance will scale linearly.
  - after that you will have to use queues and other primitives for distributed computing







### Processes

defmodule Ping do
  def await do
    receive do
      {:pong, pid} -> send(pid, {:ping, self})
    end
    await
  end
end

pid = spawn_link(Ping, :await, [])
send(pid, {:pong, self})
send(pid, {:pong, self})
flush

#####








##### GenServer (requries explicit starting)
defmodule KV do
  use GenServer
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], opts)
  end
  def init(_) do
    {:ok, HashDict.new}
  end
  def handle_call({:put, key, value}, _from, dictionary) do
    {:reply, :ok, HashDict.put(dictionary, key, value)}
  end
  def handle_call({:get, key}, _from, dictionary) do
    {:reply, HashDict.get(dictionary, key), dictionary}
  end
  def put(server, key, value) do
    GenServer.call(server, {:put, key, value})
  end
  def get(server, key) do
    GenServer.call(server, {:get, key})
  end
end




{:ok, kv_pid} = KV.start_link
KV.put(kv_pid, :a, 42)
KV.get(kv_pid, :a)



##### GenServer (Singleton pattern, uses module name as process name)
defmodule KV do
  use GenServer
  def start_link(opts \\ []) do
    # notice the extra name parameter here!
    GenServer.start_link(__MODULE__, [], [name: __MODULE__] ++ opts)
  end
  def init(_) do
    {:ok, HashDict.new}
  end
  def handle_call({:put, key, value}, _from, dictionary) do
    {:reply, :ok, HashDict.put(dictionary, key, value)}
  end
  def handle_call({:get, key}, _from, dictionary) do
    {:reply, HashDict.get(dictionary, key), dictionary}
  end

  # now the client methods use directly the name (__MODULE__)
  def put(key, value) do
    GenServer.call(__MODULE__, {:put, key, value})
  end
  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end
end

# usage
KV.start_link
KV.put(:a, 42)
KV.get(:a)
KV in Process.registered #=> true




#### GenServer: Asynchronous messaging
defmodule PingPong do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], [name: __MODULE__] ++ opts)
  end

  def ping do
    GenServer.cast(__MODULE__, {:ping, self()})
  end

  def handle_cast({:ping, from}, state) do
    send from, :pong
    {:noreply, state}
  end
end

# iex(36)> PingPong.start_link
# {:ok, #PID<0.190.0>}
# iex(37)> PingPong.ping
# :ok
# iex(38)> flush



#### Gen(eric) events


{:ok, event_manager} = GenEvent.start_link
# use GenEvent.sync_ notify/2 or GenEvent.notify/2 to send events to the manager process
GenEvent.sync_notify(event_manager, :foo)
GenEvent.notify(event_manager, :bar)

## since the event manager has no handlers, the events are dropped

defmodule Forwarder do
  use GenEvent
  def handle_event(event, parent) do
    send parent, event
    {:ok, parent}
  end
end



# iex> GenEvent.add_handler(event_manager, Forwarder, self())
# :ok
# iex> GenEvent.sync_notify(event_manager, :ping)
# :ok
# iex> flush
# :ping


defmodule Echoer do

end



