defmodule Sueldo do
  def main do
    nombre = leer("escriba el nombre del trabajador ")
    horas_trabajadas = leer_entero("escriba las horas trabajadas por el empleado ")
    precio_horas = leer_decimal("escriba el monto a pagar por hora ")
    sueldo = calcular_sueldo(horas_trabajadas, precio_horas)

    generar_mensaje(nombre, sueldo)
    |> imprimir()

  end

  def leer(mensaje) do
    IO.gets(mensaje)
  end

  def leer_decimal(numero) do
    IO.gets(numero)
    |> String.trim()
    |> String.to_float()
  end

  def leer_entero(numero) do
    IO.gets(numero)
    |> String.trim()
    |> String.to_integer()
  end

  defp calcular_sueldo(horas, precio) do
    horas*precio

  end

  defp generar_mensaje(nombre, sueldo) do
    "el salario de #{nombre} es #{sueldo}"
  end

  def imprimir (mensaje) do
      IO.puts(mensaje)
  end

end

Sueldo.main()
