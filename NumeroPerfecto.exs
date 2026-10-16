defmodule NumeroPerfecto do
  def main do
    IO.puts("Evaluando 28 con traza")
    IO.inspect(numero_perfecto(28))

    IO.puts("\n-Listando números perfectos menores a 10.000 sin trazas ")
    IO.inspect(listar_perfectos_menores(10_000))
  end

  def numero_perfecto(numero) when not is_integer(numero), do: {:error, :no_es_entero}
  def numero_perfecto(numero) when numero == 0, do: {:error, :cero_no_permitido}
  def numero_perfecto(numero) when numero < 0, do: {:error, :numero_negativo}

  def numero_perfecto(numero) do
    divisores_lista = divisores(numero)
    suma = sumar(divisores_lista)

    if numero == suma do
      true
    else
      false
    end
  end

  defp sumar(lista), do: sumar_tail(lista, 0)
  defp sumar_tail([], acc), do: acc
  defp sumar_tail([head | tail], acc), do: sumar_tail(tail, acc + head)


  #
  # original
  #
  # defp divisores(numero) do
  #   IO.puts("\nBuscando divisores para: #{numero}")
  #   divisores_tail(numero, 1, [], 1)
  # end
  #
  # # Última operación Retornar lista (Caso base)
  # defp divisores_tail(numero, acc, lista, nivel) when acc == numero do
  #   IO.puts(String.duplicate("  ", nivel) <> "Fin: acc(#{acc}) == numero(#{numero}) -> Lista final: #{inspect(lista)}")
  #   lista
  # end
  #
  # # Última operación: Llamada recursiva de cola
  # defp divisores_tail(numero, acc, lista, nivel) when rem(numero, acc) == 0 do
  #   IO.puts(String.duplicate("  ", nivel) <> "divisores_tail(#{acc}): #{acc} ES divisor de #{numero} -> Agregado")
  #   divisores_tail(numero, acc + 1, [acc | lista], nivel + 1)
  # end
  #
  # # Última operación: Llamada recursiva de cola
  # defp divisores_tail(numero, acc, lista, nivel) do
  #   IO.puts(String.duplicate("  ", nivel) <> "divisores_tail(#{acc}): #{acc} NO es divisor de #{numero}")
  #   divisores_tail(numero, acc + 1, lista, nivel + 1)
  # end


  #
  # Método optimizado (revisa solo hasta la mitad  div(numero, 2))
  # Se agrega un limite
  # frena a la mitad del número haciendo la mitad de las operaciones
  #

  defp divisores(numero) do
    IO.puts("\nBuscando divisores para: #{numero} (Optimizado)")
    limite = div(numero, 2)
    divisores_tail(numero, 1, limite, [], 1)
  end

  # ultima operación es retornar lista cuando 'acc' supera la mitad del número
  defp divisores_tail(numero, acc, limite, lista, nivel) when acc > limite do
    IO.puts(String.duplicate("  ", nivel) <> "Fin: acc(#{acc}) > limite(#{limite}) -> Lista final: #{inspect(lista)}")
    lista
  end

  # ultima operación llamada recursiva de cola agregando el divisor
  defp divisores_tail(numero, acc, limite, lista, nivel) when rem(numero, acc) == 0 do
    IO.puts(String.duplicate("  ", nivel) <> "divisores_tail(#{acc}): #{acc} es divisor de #{numero} -> Agregado")
    divisores_tail(numero, acc + 1, limite, [acc | lista], nivel + 1)
  end

  # ultima operación llamada recursiva de cola omitiendo el número
  defp divisores_tail(numero, acc, limite, lista, nivel) do
    IO.puts(String.duplicate("  ", nivel) <> "divisores_tail(#{acc}): #{acc} no es divisor de #{numero}")
    divisores_tail(numero, acc + 1, limite, lista, nivel + 1)
  end


  # Listar perfectos menores a un límite
  def listar_perfectos_menores(limite) do
    listar_perfectos_tail(1, limite, [])
  end

  defp listar_perfectos_tail(current, limite, acc) when current >= limite do
    Enum.reverse(acc)
  end

  defp listar_perfectos_tail(current, limite, acc) do
    nuevo_acc =
      case numero_perfecto_silencioso(current) do
        true -> [current | acc]
        _ -> acc
      end

    listar_perfectos_tail(current + 1, limite, nuevo_acc)
  end

  # sin trazas
  defp numero_perfecto_silencioso(numero) when not is_integer(numero) or numero < 1, do: false
  defp numero_perfecto_silencioso(numero) do
    divisores_lista = divisores_silencioso(numero, 1, div(numero, 2), [])
    sumar(divisores_lista) == numero
  end

  defp divisores_silencioso(_numero, acc, limite, lista) when acc > limite, do: lista
  defp divisores_silencioso(numero, acc, limite, lista) when rem(numero, acc) == 0 do
    divisores_silencioso(numero, acc + 1, limite, [acc | lista])
  end
  defp divisores_silencioso(numero, acc, limite, lista) do
    divisores_silencioso(numero, acc + 1, limite, lista)
  end
end

NumeroPerfecto.main()
