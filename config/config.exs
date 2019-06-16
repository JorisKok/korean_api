import Config

config :korean_api,
  postgrest_url: "http://localhost:3000"

config :korean_api, ecto_repos: [KoreanApi.Repo]

import_config "#{Mix.env()}.exs"
