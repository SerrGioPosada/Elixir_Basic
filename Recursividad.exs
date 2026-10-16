defmodule Recursividad do
  def main do
    dato = IO.gets("ingrese un numero entero y psoitivo: ")
    numero = String.trim(dato) |> String.to_integer()

    resultado = reversible?(numero)

    case resultado do
      true -> IO.puts("el numero es reversible")
      false -> IO.puts("el numero no es reversible")
      {:error, motivo} -> IO.puts("Error: #{motivo}")
    end
  end

  def reversible?(n) when is_integer(n) and n > 0 do
    if rem(n, 10) == 0 do
      false
    else
      numero_invertido = invertir(n, 0)
      son_impares?(n + numero_invertido)
    end
  end

  def reversible?(_), do: {:error, "debe ser entero y positivo"}

  def invertir(0, acc), do: acc

  def invertir(n, acc) do
    digito = rem(n, 10)
    invertir(div(n, 10), acc * 10 + digito)
  end

  def son_impares?(n, nivel \\ 0)

  def son_impares?(0, nivel) do
    IO.puts("#{String.duplicate(" ", nivel)}son_impares?(0) -> true")
    true
  end

  def son_impares?(n, nivel) do
    IO.puts("#{String.duplicate("  ", nivel)}son_impares?(#{n})")

    rem(n, 10) != 0 and rem(rem(n, 10), 2) == 1 and son_impares?(div(n, 10), nivel + 1)
  end
end

Recursividad.main()
