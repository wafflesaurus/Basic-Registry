defmodule Reg.Super do
	use Supervisor
	require Logger

	@registry_name :test_process_registry

	def start_link, do: Supervisor.start_link(__MODULE__, [], name: __MODULE__)

	def create_account_process(id) when is_integer(id) do
    case Supervisor.start_child(__MODULE__, [id]) do
      {:ok, _pid} -> {:ok, id}
      {:error, {:already_started, _pid}} -> {:error, :process_already_exists}
      other -> {:error, other}
    end
  end

	def account_ids do
    Supervisor.which_children(__MODULE__)
    |> Enum.map(fn {_, account_proc_pid, _, _} ->
      Registry.keys(@registry_name, account_proc_pid)
      |> List.first
    end)
    |> Enum.sort
  end

	def init(_) do
		children = [
			worker(Reg.Worker, [], restart: :temporary)
		]

		supervise(children, strategy: :simple_one_for_one)
	end
end
