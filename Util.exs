defmodule Util do

  def leer(mensaje, :string) do
    IO.gets(mensaje)
    |> String.trim()
  end

  def leer(mensaje, :integer) do
    entrada = leer(mensaje, :string)

    case Integer.parse(entrada) do
      {numero, ""} ->
        numero

      _ ->
        imprimir_error("Error: Entrada numérica entera no válida.")
        :error
    end
  end

  def leer(mensaje, :float) do
    entrada = leer(mensaje, :string)

    case Float.parse(entrada) do
      {numero, ""} ->
        numero

      _ ->
        imprimir_error("Error: Entrada numérica decimal no válida.")
        :error
    end
  end

  def imprimir_mensaje(mensaje) do
    IO.puts(mensaje)
  end

  def imprimir_error(mensaje) do
    IO.puts(:standard_error, mensaje)
  end

end
