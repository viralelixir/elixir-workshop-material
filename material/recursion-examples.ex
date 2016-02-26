# not tail-call-optimized
defmodule Fib do
  def fib(0) do 0 end
  def fib(1) do 1 end
  def fib(n) do fib(n-1) + fib(n-2) end
end

IO.puts Fib.fib(10)



# tail-call optimized function
defmodule Fib do
  def fib(a, _, 0 ) do a end

  def fib(a, b, n) do fib(b, a+b, n-1) end

end
IO.puts Fib.fib(1,1,6)

