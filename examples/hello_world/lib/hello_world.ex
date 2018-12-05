defmodule HelloWorld do
  @moduledoc """
  Entrypoint for my hello world Lambda function.
  """

  require Logger

  @doc """
  The lambda entrypoint is just a public function in a module which accepts
  two maps.
  The returned term will be passed to Poison for Json Encoding.
  """
  @spec hello_world(Map.t(), Map.t()) :: Term
  def hello_world(request, context) when is_map(request) and is_map(context) do
    """
    Hello World!
    Got reqeust #{Kernel.inspect(request)}
    Got Context #{Kernel.inspect(context)}
    """
    |> Logger.info()

    :ok
  end
end
