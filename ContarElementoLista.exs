defmodule ContarElementoLista do
  def main do
    IO.inspect(contar_elemento_lista([1, "cafe", :ok, 4, "cafe", 1, "pasilla", :ok, 1, "cafe"]))
    IO.inspect(contar_elemento_lista([10, "finca", :lote_a, true, 10, "cosecha", :lote_a, "finca", 10, false, "cosecha", :lote_a]))
  end

  def contar_elemento_lista(lista), do: contar_elemento_lista_tail(lista, %{})

  defp contar_elemento_lista_tail([], mapa), do: mapa
  defp contar_elemento_lista_tail([head | tail], mapa) do
    nuevo_mapa =
      if Map.has_key?(mapa, head) do
        mapa
      else
        Map.put(mapa, head, contar_elemento(head, [head | tail]))
      end

    contar_elemento_lista_tail(tail, nuevo_mapa)
  end

  defp contar_elemento(elemento, lista), do: contar_elemento_tail(elemento, lista, 0)

  defp contar_elemento_tail(_e, [], acc), do: acc
  defp contar_elemento_tail(e, [head | tail], acc) when e == head, do: contar_elemento_tail(e, tail, acc+1)
  defp contar_elemento_tail(e, [_head | tail], acc), do: contar_elemento_tail(e, tail, acc)

end

ContarElementoLista.main()
