defmodule ContarVocales do
  def main do
IO.puts("pruebas Implementación A ")
    IO.inspect(contar_vocales_a("murciélago"))
    IO.inspect(contar_vocales_a("Canción ÚNICA"))
    IO.inspect(contar_vocales_a("Pingüino"))
    IO.inspect(contar_vocales_a("Programación III"))
    IO.inspect(contar_vocales_a("xyz"))
    IO.inspect(contar_vocales_a(""))
    IO.inspect(contar_vocales_a(123))

    IO.puts("\n pruebas Implementación B ")
    IO.inspect(contar_vocales_b("murciélago"))
    IO.inspect(contar_vocales_b("Canción ÚNICA"))
    IO.inspect(contar_vocales_b("Pingüino"))
    IO.inspect(contar_vocales_b("Programación III"))
    IO.inspect(contar_vocales_b("xyz"))
    IO.inspect(contar_vocales_b(""))
    IO.inspect(contar_vocales_b(123))

    IO.inspect(contar_vocales_a("café"))
    IO.inspect(contar_vocales_b("café"))
  end

  #Implementacion A

  def contar_vocales_a(cadena) when not is_binary(cadena) do
    {:error, :no_es_una_cadena}
  end

  def contar_vocales_a(cadena) do
    IO.puts("\n[Imp A] Analizando cadena: '#{cadena}'")
    graphemes = String.graphemes(cadena)
    contar_vocales_a_tail(graphemes, 0, 1)
  end

  defp contar_vocales_a_tail([], acc, nivel) do
    IO.puts(String.duplicate("  ", nivel) <> "[Imp A] Fin de cadena. Total vocales: #{acc}")
    acc
  end

  defp contar_vocales_a_tail([head | tail], acc, nivel) do
    if es_vocal?(head) do
      IO.puts(String.duplicate("  ", nivel) <> "[Imp A] '#{head}' es vocal -> aumenta +1")
      contar_vocales_a_tail(tail, acc + 1, nivel + 1)
    else
      IO.puts(String.duplicate("  ", nivel) <> "[Imp A] '#{head}' no es vocal")
      contar_vocales_a_tail(tail, acc, nivel + 1)
    end
  end


  #Implementacion B

  def contar_vocales_b(cadena) when not is_binary(cadena) do
    {:error, :no_es_una_cadena}
  end

  def contar_vocales_b(cadena) do
    IO.puts("\n[Imp B] Analizando cadena: '#{cadena}'")
    contar_vocales_b_tail(cadena, 0, 1)
  end

  defp contar_vocales_b_tail("", acc, nivel) do
    IO.puts(String.duplicate("  ", nivel) <> "[Imp B] Fin de binario. Total vocales: #{acc}")
    acc
  end

  defp contar_vocales_b_tail(<<head::utf8, rest::binary>>, acc, nivel) do
    # ----------IA-------------
    caracter = <<head::utf8>>

    if es_vocal?(caracter) do
      IO.puts(String.duplicate("  ", nivel) <> "[Imp B] '#{caracter}' (código #{head}) ES vocal -> Acumula (+1)")
      contar_vocales_b_tail(rest, acc + 1, nivel + 1)
    else
      IO.puts(String.duplicate("  ", nivel) <> "[Imp B] '#{caracter}' (código #{head}) NO es vocal")
      contar_vocales_b_tail(rest, acc, nivel + 1)
    end
  end



  defp es_vocal?(char) do

    char_minus = String.downcase(char)

    vocales = ["a", "á", "e", "é", "i", "í", "o", "ó", "u", "ú", "ü"]
    char_minus in vocales
  end
end

ContarVocales.main()
