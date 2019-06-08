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

  # The Open API docs are not properly forwarded via the ReverseProxyPlug
  get "/" do
    HTTPoison.start()
    response = HTTPoison.get!(Application.fetch_env!(:korean_api, :postgrest_url))

    conn
    |> put_resp_content_type("application/openapi+json")
    |> send_resp(200, response.body)
  end

  get "/words" do
    conn
    |> put_resp_content_type("application/openapi+json")
    |> send_resp(200, KoreanApi.Controllers.WordController.get(conn.query_string))
  end

  # Forward everything to PostgREST
  forward("/", to: ReverseProxyPlug, upstream: Application.fetch_env!(:korean_api, :postgrest_url))  # TODO get url from config
end
