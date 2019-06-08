import Config


config :korean_api,
  postgrest_url: "http://localhost:3000"

config :korean_api, ecto_repos: [KoreanApi.Repo]

config :korean_api, KoreanApi.Repo,
  database: "korean_api",
  # TODO change for production
  username: "korean_api",
  # TODO change for production
  password: "korean_api",
  hostname: "localhost",
  port: "5432"

import_config "#{Mix.env()}.exs"
