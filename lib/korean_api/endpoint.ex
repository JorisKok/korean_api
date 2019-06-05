defmodule KoreanApi.Endpoint do
  use Plug.Router

  plug(:match)

  plug(
    Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  )

  plug(:dispatch)

  get "/ping" do
    send_resp(conn, 200, "pong!")
  end

  @shortdoc "The Open API docs are not properly forwarded via the ReverseProxyPlug"
  get "/" do
    HTTPoison.start
    response = HTTPoison.get! "http://localhost:3000"

    conn
    |> put_resp_content_type("application/openapi+json")
    |> send_resp(200, response.body)
  end

  @shortdoc "Forward everything to PostgREST"
  forward("/", to: ReverseProxyPlug, upstream: "//0.0.0.0:3000/")
end