defmodule Estudiantes do
  def main do
    lista = [3, 4, 4.6, 1.6, 2.3, 4.5, 1]

    case obtener_promedio(lista) do
      {:ok, respuesta} -> IO.puts("El promedio es: #{respuesta}")
      {:error, respuesta} -> IO.puts("Error: #{respuesta}")
    end

  end

  def obtener_promedio([]) do
    {:error, "La lista está vacía"}
  end

  def obtener_promedio(lista) do
    suma =Enum.sum(lista)
    {:ok, suma / length(lista)}
  end

  def contar_estudiantes(lista, promedio) do
    Enum.count(lista, fn x -> x > promedio end)
  end
end
Estudiantes.main()
