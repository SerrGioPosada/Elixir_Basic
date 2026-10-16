defmodule PalindromoRecursivo do
  def main do
    IO.inspect(palindromo?("Reconocer"))
    IO.inspect(palindromo?("La ruta nos aportó otro paso natural"))
    IO.inspect(palindromo?("Elefante"))
    IO.inspect(palindromo?("Rotator"))
    IO.inspect(palindromo?("Ayer fuimos a la finca"))
  end

  def palindromo?(cadena) do
    cadena_limpia = limpiar_cadena(cadena)

    case es_palindromo_rec?(cadena_limpia, cadena_limpia) do
      {true, len} -> {:true, cadena, "es palindroma", "longitud: #{len}"}
      {false, len} -> {:false, cadena, "no es palindroma", "longitud: #{len}"}
    end
  end


  defp es_palindromo_rec?(cadena_izq, cadena_der) do
    evaluar_extremos(cadena_izq, cadena_der, "", 0)
  end


  defp evaluar_extremos("", _der, _acc_der, len), do: {true, len}

  defp evaluar_extremos(izq, der, acc_der, len) do
    case {String.next_grapheme(izq), obtener_ultimo_grapheme(der, acc_der)} do

      {nil, _} ->
        {true, len}


      {{char_izq, rest_izq}, {char_der, rest_der}} when char_izq == char_der ->
        evaluar_extremos(rest_izq, rest_der, "", len + 1)

      _ ->
        {false, len}
    end
  end


  defp obtener_ultimo_grapheme(cadena, acc) do
    case String.next_grapheme(cadena) do
      nil -> {acc, ""}
      {head, ""} when acc == "" -> {head, ""}
      {head, rest} -> obtener_ultimo_grapheme(rest, head)
    end
  end


  defp limpiar_cadena(cadena) do
    cadena
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9]/, "")
  end
end

PalindromoRecursivo.main()

@doc"""

defmodule PalindromoGrafemas do
  def palindromo?(cadena) do
    grafemas =
      cadena
      |> String.downcase()
      |> String.replace(~r/[^a-z0-9]/, "")
      |> String.graphemes()

    verificar_extremos(grafemas, 0)
  end

  # Caso base 1: Lista vacía (longitud par) -> Es palíndromo
  defp verificar_extremos([], acc_len), do: {true, acc_len}

  # Caso base 2: Un solo elemento en el centro (longitud impar) -> Es palíndromo
  defp verificar_extremos([_centro], acc_len), do: {true, acc_len + 1}

  # Caso recursivo: Compara el primero (head) y el último (last)
  defp verificar_extremos(lista, acc_len) do
    head = List.first(lista)
    last = List.last(lista)

    if head == last do
      # Extraemos el centro removiendo el primero y el último
      centro = lista |> Enum.drop(1) |> Enum.drop(-1)
      verificar_extremos(centro, acc_len + 2)
    else
      # Salida temprana (Short-circuit)
      {false, acc_len}
    end
  end
end
"""
