defmodule Weber do

  use Application.Behaviour

  require Weber.Templates.ViewsLoader

  @moduledoc """
  Main Weber module. Starts Weber application.
  """

  @doc """
  Start new Weber application instance with given
  application name, web application's root
  directory and config from config.ex.
  """
  def run_weber do
    start([], [])
  end

  @doc """
  Start weber application
  """
  def start(_type, _args) do
    case :lists.keyfind(:log, 1, Config.config) do
      {:ok, true} ->
        :ok = :application.start(:compiler)
        :ok = :application.start(:syntax_tools)
        :ok = :application.start(:goldrush)
        :ok = :application.start(:lager)
        :ok = :application.start(:exlager) 
      _ ->
        :ok
    end
    # start cowboy
    Cowboy.start(Config.config)
    # start session manager
    Weber.Session.SessionManager.start_link(Config.config)
    # start localization manager
    Weber.Localization.LocalizationManager.start_link(Config.config)
  end

  @doc """
  Stop weber application.
  """
  def stop(_state) do
    :ok
  end

end