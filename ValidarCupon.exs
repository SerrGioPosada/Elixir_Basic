defmodule ValidarCupon do
   def main do

    cupon = Util.leer("Escriba el número del cupón: ", :string)
    resultado = {cupon, ""}
    |> validar_longitud()
    |> validar_mayuscula()
    |> validar_numero()
    |> validar_espacios()
    |> construir_resultado()

    case resultado do
    {:ok, mensaje} ->
      Util.imprimir_mensaje( mensaje)

    {:error, errores} ->
      Util.imprimir_mensaje("ERROR: El cupón no es válido: " <> errores)
   end
   end

  defp agregar_error("", nuevo_error), do: nuevo_error
  defp agregar_error(errores, nuevo_error), do: errores <> ", " <> nuevo_error

   #validar Longitud

  defp verificar_longitud({cupon, errores}, true), do: {cupon, agregar_error(errores, "debe tener al menos 10 caracteres")}
  defp verificar_longitud({cupon, errores}, false), do: {cupon, errores}

   def validar_longitud({cupon, errores}) do
    verificar_longitud({cupon, errores}, String.length(cupon) < 10)
   end

   #validar mayuscula

  defp verificar_mayuscula({cupon, errores}, true), do: {cupon, agregar_error(errores, "debe tener al menos una mayuscula")}
  defp verificar_mayuscula({cupon, errores}, false), do: {cupon, errores}

   def validar_mayuscula({cupon, errores}) do
     verificar_mayuscula({cupon, errores}, cupon== String.downcase(cupon))
   end

   #validar numero

  defp verificar_numero({cupon, errores}, true), do: {cupon, errores}
  defp verificar_numero({cupon, errores}, false), do: {cupon, agregar_error(errores, "debe tener al menos un numero")}

   def validar_numero({cupon, errores}) do

    sin_numeros =
    cupon
    |> String.replace("0", "")
    |> String.replace("1", "")
    |> String.replace("2", "")
    |> String.replace("3", "")
    |> String.replace("4", "")
    |> String.replace("5", "")
    |> String.replace("6", "")
    |> String.replace("7", "")
    |> String.replace("8", "")
    |> String.replace("9", "")

  tiene_numero? = String.length(sin_numeros) < String.length(cupon)

  verificar_numero({cupon, errores}, tiene_numero?)
   end

   #validar espacio

  defp verificar_espacios({cupon, errores}, true), do: {cupon, agregar_error(errores, "no debe contener espacios")}
  defp verificar_espacios({cupon, errores}, false), do: {cupon, errores}

   def validar_espacios({cupon, errores}) do
    verificar_espacios({cupon, errores}, String.contains?(cupon, " "))
  end

  #resultado

  def construir_resultado({_cupon, ""}), do: {:ok, "Cupón válido"}
  def construir_resultado({_cupon, errores}), do: {:error, errores}

end

ValidarCupon.main()
