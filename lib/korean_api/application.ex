defmodule KoreanApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: KoreanApi.Worker.start_link(arg)
      # {KoreanApi.Worker, arg}
      KoreanApi.Repo,
      Plug.Cowboy.child_spec(scheme: :http, plug: KoreanApi.Endpoint, options: [port: 4001])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KoreanApi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
