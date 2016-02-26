iex> Process.registered

[:user_drv, :standard_error, Logger.Watcher, Logger, :kernel_safe_sup,
 Logger.Supervisor, :elixir_sup, :inet_db, :rex, :kernel_sup,
 :global_name_server, :standard_error_sup, :init, :file_server_2, :user,
 :global_group, IEx.Config, :elixir_counter, :dets_sup, :elixir_config, :dets,
 :elixir_code_server, :code_server, :error_logger, :erl_prim_loader,
 :application_controller, IEx.Supervisor]



iex> :application.which_applications
[{:stdlib, 'ERTS  CXC 138 10', '2.5'}, {:elixir, 'elixir', '1.0.5'},
 {:kernel, 'ERTS  CXC 138 10', '4.0'}, {:iex, 'iex', '1.0.5'},
 {:logger, 'logger', '1.0.5'}, {:compiler, 'ERTS  CXC 138 10',
'6.0'},
 {:syntax_tools, 'Syntax tools', '1.7'}, {:crypto, 'CRYPTO', '3.6'}]


iex> Process.list





 # https://github.com/tbohnen/ConferenceTalks/blob/master/LearningElixir/examples/supervisor/supervisor.exs
defmodule Me.Worker do
  use GenServer

  def start_link(name) do
    res = GenServer.start_link(__MODULE__, :ok, name: name)
    IO.puts "started worker"
    res
  end

  def handle_call({:ok, state}, _from, _) do
    IO.puts "received call with state #{state}"
    :correct = state
    {:reply, [], []}
  end

  def correct(name) do
    GenServer.call(name, {:ok, :correct})
  end

  def incorrect(name) do
    GenServer.call(name, {:ok, :incorrect})
  end

end

defmodule Me.Supervisor do
  use Supervisor

  def start_link() do
    res = Supervisor.start_link(__MODULE__, :ok)
    IO.puts "Started Supervisor"
    res
  end

  def init(:ok) do
    children = [worker(Me.Worker, [:supervised])]
    supervise(children, strategy: :one_for_one)
  end
end

defmodule Examples do

  def unsupervised() do
    IO.gets "start Genserver without supervisor"
    Me.Worker.start_link(:unsupervised)
    IO.gets "call with no failure"
    Me.Worker.correct(:unsupervised)
    IO.gets "call with failure"
    Me.Worker.incorrect(:unsupervised)
  end

  def supervised() do
    IO.gets "start Genserver with supervisor"
    Me.Supervisor.start_link()
    IO.gets "call with no failure"
    Me.Worker.correct(:supervised)
    IO.gets "call with failure"
    Me.Worker.incorrect(:supervised)
  end

  def where() do
    IO.puts "Supervised PID #{inspect Process.whereis(:supervised)}"
    IO.puts "Unsupervised PID #{inspect Process.whereis(:unsupervised)}"
  end

end
