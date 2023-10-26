defmodule ErlfmtFormatterPlugin do
  @moduledoc """
  Mix formatter plugin to format Erlang code with `erlfmt`.

  ## Setup

  Add `ErlfmtFormatterPlugin` to `:plugins` configuration in `.formatter.exs`:

      [
        plugins: [ErlfmtFormatterPlugin],
        inputs: ["**/*.{erl,hrl}"]
      ]

  Then run `mix deps.compile` to make `ErlfmtFormatterPlugin` available.
  """

  @behaviour Mix.Tasks.Format

  @impl true
  def features(_opts) do
    [sigils: [], extensions: [".erl", ".hrl"]]
  end

  @impl true
  def format(contents, _opts) do
    case :erlfmt.format_string(String.to_charlist(contents), []) do
      {:ok, formatted_erl, []} ->
        to_string(formatted_erl)

      {:ok, _, error_infos} ->
        Mix.raise(format_errors(error_infos))
    end
  end

  defp format_errors(error_infos) do
    error_infos
    |> Enum.map(&:erlfmt.format_error_info/1)
    |> Enum.join("\n")
  end
end
