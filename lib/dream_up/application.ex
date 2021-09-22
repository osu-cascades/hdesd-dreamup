defmodule DreamUp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    Vapor.load!([%Vapor.Provider.Dotenv{}])
    config = load_system_env() |> Enum.map(
      fn x ->
        {atom, str} = x
        {atom, String.replace(str, "\r", "")}
      end
    )

    children = [
      # Start the Ecto repository
      {DreamUp.Repo, [username: config[:username], password: config[:password]]},
      # Start the Telemetry supervisor
      DreamUpWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: DreamUp.PubSub},
      # Start the Endpoint (http/https)
      {DreamUpWeb.Endpoint, [secret_key_base: config[:secret_key_base], url: [scheme: "https", host: config[:url], port: 443]]}
      # Start a worker by calling: DreamUp.Worker.start_link(arg)
      # {DreamUp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DreamUp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp load_system_env() do
    providers = %Vapor.Provider.Env{bindings: [
      {:secret_key_base, "SECRET_KEY_BASE"},
      {:username, "DATABASE_USERNAME"},
      {:password, "DATABASE_PASSWORD"},
      {:url, "SITE_URL"}
    ]}

    {_, config} = Vapor.Provider.load(providers)
    config
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DreamUpWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
