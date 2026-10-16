defmodule Videojuego do
  def main do
    mensaje = saludar()
    imprimi_mensaje = (mensaje)

  end


  defp saludar(nombre \\"invitado") do
    "Bienvenido #{nombre}, al videojuego aventura espacial"
  end

  def imprimir_mensaje(mensaje) do
      IO.puts(mensaje)
  end

  def
end

Videojuego.main()
