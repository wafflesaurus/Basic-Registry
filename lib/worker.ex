defmodule Reg.Worker do
	use GenServer
	require Logger

	@registry_name :test_process_registry

	defstruct id: 0,
            name: "",
            some_attribute: ""

	def start_link(id) when is_integer(id) do
		GenServer.start_link(__MODULE__, [id], name: via_tuple(id))
	end

	defp via_tuple(id), do: {:via, Registry, {@registry_name, id}}

	def init([id]) do
		Logger.info("Process created... ID: #{id}")

    # Set initial state and return from `init`
    {:ok, %__MODULE__{ id: id }}
	end
end
