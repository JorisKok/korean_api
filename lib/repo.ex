defmodule KoreanApi.Repo do
  use Ecto.Repo,
    otp_app: :korean_api,
    adapter: Ecto.Adapters.Postgres
end