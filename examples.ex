

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



# has tail call optimization, so we want have problems with our stack
# you could do that in Ruby, but you would have problems with big lists, because each iteration is costing
# a jump in the stack





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
