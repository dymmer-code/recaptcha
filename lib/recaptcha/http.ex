defmodule Recaptcha.Http do
  @moduledoc """
  Responsible for managing HTTP requests to the reCAPTCHA API.
  """
  use Tesla, only: [:post], docs: false

  require Logger

  plug(
    Tesla.Middleware.BaseUrl,
    Application.get_env(:recaptcha, :verify_url, @default_verify_url)
  )

  plug(Tesla.Middleware.Headers, [
    {"Content-type", "application/x-www-form-urlencoded"},
    {"Accept", "application/json"}
  ])

  plug(Tesla.Middleware.DecodeJson)

  plug(Tesla.Middleware.Logger,
    format: "$method $url ===> $status / time=$time",
    log_level: :debug
  )

  @default_verify_url "https://www.google.com/recaptcha/api/siteverify"

  @doc """
  Sends an HTTP request to the reCAPTCHA version 2.0 API.

  See the [docs](https://developers.google.com/recaptcha/docs/verify#api-response)
  for more details on the API response.

  ## Options

    * `:timeout` - the timeout for the request (defaults to 5000ms)

  ## Examples

      {:ok, %{
        "success" => success,
        "challenge_ts" => ts,
        "hostname" => host,
        "error-codes" => errors
      }} = Recaptcha.Http.request_verification(%{
        secret: "secret",
        response: "response",
        remote_ip: "remote_ip"
      })

  """
  @spec request_verification(binary, Keyword.t()) ::
          {:ok, map} | {:error, [atom]}
  def request_verification(body, options \\ []) do
    timeout =
      options[:timeout] || Application.get_env(:recaptcha, :timeout, 5_000)

    opts = [{:timeout, timeout} | options]

    case post("", body, opts) do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %Tesla.Env{status: status, body: body}} when status >= 400 ->
        Logger.error("captch error, body: #{inspect(body)}")
        {:error, [:invalid_api_response]}

      {:error, reason} ->
        {:error, [reason]}
    end
  end
end
