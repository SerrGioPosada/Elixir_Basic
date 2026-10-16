defmodule Potencias do
  def main do
    IO.puts("CASOS DE PRUEBA")

    IO.inspect({16, 2, potencia_de?(16, 2)})
    IO.inspect({64, 4, potencia_de?(64, 4)})
    IO.inspect({50, 10, potencia_de?(50, 10)})
    IO.inspect({1, 5, potencia_de?(1, 5)})
    IO.inspect({2, 4, potencia_de?(2, 4)})

    IO.inspect({
      1_267_650_600_228_229_401_496_703_205_376,
      2,
      potencia_de?(1_267_650_600_228_229_401_496_703_205_376, 2)
    })

    IO.inspect({
      1_267_650_600_228_229_401_496_703_205_377,
      2,
      potencia_de?(1_267_650_600_228_229_401_496_703_205_377, 2)
    })

    IO.inspect({16, 1, potencia_de?(16, 1)})
    IO.inspect({0, 2, potencia_de?(0, 2)})
    IO.inspect({-8, 2, potencia_de?(-8, 2)})

    IO.puts("\nTRAZA DE EJECUCION")

    potencia_de?(16, 2, 0)
  end

  def potencia_de?(1, _b), do: true

  # Caso recursivo
  def potencia_de?(n, b) do
    if rem(n, b) == 0 do
      potencia_de?(div(n, b), b)
    else
      false
    end
  end

  def potencia_de?(1, b, nivel) do
    espacios = String.duplicate("  ", nivel)
    IO.puts("#{espacios}Llamada: potencia_de?(1, #{b})")
    IO.puts("#{espacios}Retorno: true")
    true
  end

  def potencia_de?(n, b, nivel) do
    espacios = String.duplicate("  ", nivel)
    IO.puts("#{espacios}Llamada: potencia_de?(#{n}, #{b})")

    if rem(n, b) == 0 do
      resultado = potencia_de?(div(n, b), b, nivel + 1)
      IO.puts("#{espacios}Retorno: #{inspect(resultado)}")
      resultado
    else
      IO.puts("#{espacios}Retorno: false")
      false
    end
  end
end

Potencias.main()
