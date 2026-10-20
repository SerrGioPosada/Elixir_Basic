defmodule NumerosPosicionPar do
  def main do

    IO.inspect(cadena_posicion_lista([1, 2, 3, 4, 5], :par))
    IO.inspect(cadena_posicion_lista([1, 2, 3, 4, 5], :impar))
  end

  def cadena_posicion_lista(lista, posicion)do
     tail_posicion_lista(lista, posicion, [], 0)
  end

  defp tail_posicion_lista([], _posicion, nueva_lista, _current), do: Enum.reverse(nueva_lista) |> convertir_lista_cadena()

  defp tail_posicion_lista([head | tail], posicion, nueva_lista, current) when rem(current, 2) != 0 and posicion == :impar do
    tail_posicion_lista(tail, posicion, [head | nueva_lista], current+1)
  end

  defp tail_posicion_lista([head | tail], posicion, nueva_lista, current) when rem(current, 2) == 0 and posicion == :par do
    tail_posicion_lista(tail, posicion, [head | nueva_lista], current+1)
  end

  defp tail_posicion_lista([_head | tail], posicion, nueva_lista, current), do: tail_posicion_lista(tail, posicion, nueva_lista, current+1)

  defp convertir_lista_cadena(lista), do: convertir_cadena_tail(lista, "")

  defp convertir_cadena_tail([], cadena), do: cadena
  defp convertir_cadena_tail([head | tail], cadena) do
    convertir_cadena_tail(tail, cadena <> Integer.to_string(head))
  end
end
NumerosPosicionPar.main()
