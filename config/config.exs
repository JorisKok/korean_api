import Config

config :korean_api, ecto_repos: [KoreanApi.Repo]

config :korean_api, KoreanApi.Repo,
       database: "korean_api",
       username: "korean_api", # TODO change for production
       password: "korean_api", # TODO change for production
       hostname: "localhost",
       port: "5432"

import_config "#{Mix.env()}.exs"
