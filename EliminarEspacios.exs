defmodule EliminarEspacios do
  def main do
    IO.inspect(eliminar_espacios("Rec ono cer"))
    IO.inspect(eliminar_espacios("La ruta nos aportó otro paso natural"))
    IO.inspect(eliminar_espacios("Elefante"))
    IO.inspect(eliminar_espacios("Ro tator"))
    IO.inspect(eliminar_espacios("Ayer fuimos a la finca"))
  end

  def eliminar_espacios(""), do: {:error, :cadena_vacia}
  def eliminar_espacios(cadena), do: eliminar_espacios_tail(cadena, "")

  defp eliminar_espacios_tail("", acc), do: acc

  defp eliminar_espacios_tail(<<head::utf8, rest::binary>>, acc) when head == ?\s, do: eliminar_espacios_tail(rest, acc)

  defp eliminar_espacios_tail(<<head::utf8, rest::binary>>, acc), do: eliminar_espacios_tail(rest, acc <> <<head::utf8>>)

end

EliminarEspacios.main()
