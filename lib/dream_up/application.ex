defmodule DreamUp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    Vapor.load!([%Vapor.Provider.Dotenv{}])
    config = load_system_env()
    IO.puts("----ENVIRONMENT VARIABLES----")
    IO.inspect(config)

    children = [
      # Start the Ecto repository
      {DreamUp.Repo, username: config.username, password: config.password},
      # Start the Telemetry supervisor
      DreamUpWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: DreamUp.PubSub},
      # Start the Endpoint (http/https)
      {DreamUpWeb.Endpoint, secret_key_base: config.secret_key_base}
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
      {:secret_key_base, "CONFIG_SECRET_KEY"},
      {:username, "DATABASE_USERNAME_DEV"},
      {:password, "DATABASE_PASSWORD_DEV"},
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
