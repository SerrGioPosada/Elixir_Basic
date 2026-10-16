defmodule NumerosPosicionPar do
  def main do

    IO.puts(cadena_posicion_lista([1, 2, 3, 4, 5], :par))
  end

  def cadena_posicion_lista(lista, atomo) do
    case atomo do
      :par -> elementos_posicion_par(lista)
      |> cadena_elementos()
      _ -> {:error, "La posicion debe ser par o impar"}
    end
  end

    defp elementos_posicion_par(lista), do: elementos_posicion_par_tail(lista, 0, [])

    defp elementos_posicion_par_tail(lista, current, acc ) when current > length(lista), do: acc
    defp elementos_posicion_par_tail([head | tail], current, acc ) when rem(current, 2) == 0 do
      elementos_posicion_par_tail(tail, current+1, [head | acc])
    end

    defp cadena_elementos(lista), do: cadena_elementos_tail(lista, "")

    defp cadena_elementos_tail([], acc), do: acc
    defp cadena_elementos_tail([head | tail], acc), do: cadena_elementos_tail(tail, head <> acc)

end
NumerosPosicionPar.main()
