defmodule PaqueteTuristico do
  # Destinos
  @bogota 1
  @medellin 2
  @cartagena 3
  @san_andres 4
  # Tarifas de vuelo
  @tarifa_bogota 180_000.0
  @tarifa_medellin 150_000.0
  @tarifa_cartagena 220_000.0
  @tarifa_san_andres 280_000.0

  # Maleta
  @valor_maleta 45000.0

  # Tarifas de hotel por noche
  @tarifa_hotel_1_2 120_000.0
  @tarifa_hotel_3_5 100_000.0
  @tarifa_hotel_6_31 85000.0

  # Descuentos por tipo de cliente
  @descuento_frecuente 0.20
  @descuento_corporativo 0.15
  @descuento_ocasional 0.0

  # Recargos por temporada
  @recargo_diciembre_enero 0.25
  @recargo_junio_julio 0.10
  @recargo_normal 0.0

  # Seguro
  @valor_seguro_noche 12000.0

  # Descuento del paquete
  @descuento_paquete 0.05

  def main do
    destino = Util.leer("Ingrese el destino (1-4): ", :entero)
    noches = Util.leer("Ingrese el número de noches (1-31): ", :entero)

    tipo_cliente =
      Util.leer(
        "Ingrese el tipo de cliente (frecuente, corporativo, ocasional): ",
        :cadena
      )

    mes = Util.leer("Ingrese el mes (1-12): ", :entero)
    maleta = Util.leer("¿Desea maleta? (si/no): ", :cadena)
    seguro = Util.leer("¿Desea seguro? (si/no): ", :cadena)

    resultado =
      calcular_paquete(
        destino,
        noches,
        tipo_cliente,
        mes,
        maleta,
        seguro
      )

    mostrar_resultado(resultado)
  end

  def calcular_paquete(destino, noches, tipo_cliente, mes, maleta, seguro) do
    with {:ok, destino} <- validar_destino(destino),
         {:ok, noches} <- validar_noches(noches),
         {:ok, cliente} <- validar_cliente(tipo_cliente),
         {:ok, mes} <- validar_mes(mes),
         {:ok, {valor_maleta, origen_maleta}} <-
           calcular_maleta(destino, maleta),
         {:ok, tarifa_vuelo} <- obtener_tarifa_vuelo(destino),
         {:ok, tarifa_noche} <- obtener_tarifa_noche(noches),
         {:ok, {subtotal_hotel, descuento, recargo}} <-
           calcular_hotel(tarifa_noche, noches, cliente, mes),
         {:ok, valor_seguro} <- calcular_seguro(noches, seguro),
         {:ok, descuento_paquete} <-
           calcular_descuento_paquete(noches, subtotal_hotel, valor_seguro),
         {:ok, total} <-
           calcular_total(
             tarifa_vuelo,
             valor_maleta,
             subtotal_hotel,
             valor_seguro,
             descuento_paquete
           ) do
      {:ok,
       {
         {tarifa_vuelo, valor_maleta, origen_maleta},
         {tarifa_noche, subtotal_hotel, descuento, recargo},
         {valor_seguro, descuento_paquete, total}
       }}
    else
      {:error, razon} ->
        {:error, razon}
    end
  end

  defp validar_destino(destino) when destino >= 1 and destino <= 4 do
    {:ok, destino}
  end

  defp validar_destino(_destino) do
    {:error, "El destino no es válido"}
  end

  defp validar_noches(noches) when noches >= 1 and noches <= 31 do
    {:ok, noches}
  end

  defp validar_noches(_noches) do
    {:error, "El número de noches debe estar entre 1 y 31"}
  end

  defp validar_mes(mes) when mes >= 1 and mes <= 12 do
    {:ok, mes}
  end

  defp validar_mes(_mes) do
    {:error, "El mes debe estar entre 1 y 12"}
  end

  defp validar_cliente(tipo_cliente) do
    tipo_cliente
    |> String.downcase()
    |> validar_tipo_cliente()
  end

  defp validar_tipo_cliente("frecuente") do
    {:ok, :frecuente}
  end

  defp validar_tipo_cliente("corporativo") do
    {:ok, :corporativo}
  end

  defp validar_tipo_cliente("ocasional") do
    {:ok, :ocasional}
  end

  defp validar_tipo_cliente(_tipo_cliente) do
    {:error, "El tipo de cliente no es válido"}
  end

  defp obtener_tarifa_vuelo(@bogota) do
    {:ok, @tarifa_bogota}
  end

  defp obtener_tarifa_vuelo(@medellin) do
    {:ok, @tarifa_medellin}
  end

  defp obtener_tarifa_vuelo(@cartagena) do
    {:ok, @tarifa_cartagena}
  end

  defp obtener_tarifa_vuelo(@san_andres) do
    {:ok, @tarifa_san_andres}
  end

  defp obtener_tarifa_noche(noches) when noches >= 1 and noches <= 2 do
    {:ok, @tarifa_hotel_1_2}
  end

  defp obtener_tarifa_noche(noches) when noches >= 3 and noches <= 5 do
    {:ok, @tarifa_hotel_3_5}
  end

  defp obtener_tarifa_noche(noches) when noches >= 6 and noches <= 31 do
    {:ok, @tarifa_hotel_6_31}
  end

  defp calcular_maleta(destino, maleta) do
    maleta
    |> String.downcase()
    |> calcular_maleta_por_destino(destino)
  end

  # Guard: San Andrés obliga la maleta
  defp calcular_maleta_por_destino(_maleta, destino)
       when destino == @san_andres do
    {:ok, {@valor_maleta, :automatica}}
  end

  defp calcular_maleta_por_destino("si", _destino) do
    {:ok, {@valor_maleta, :solicitada}}
  end

  defp calcular_maleta_por_destino("no", _destino) do
    {:ok, {0.0, :no_incluida}}
  end

  defp calcular_maleta_por_destino(_maleta, _destino) do
    {:error, "La respuesta para la maleta debe ser si o no"}
  end

  defp calcular_hotel(tarifa_noche, noches, cliente, mes) do
    descuento_por_cliente =
      case cliente do
        :frecuente ->
          @descuento_frecuente

        :corporativo ->
          @descuento_corporativo

        :ocasional ->
          @descuento_ocasional
      end

    subtotal = tarifa_noche * noches

    descuento = subtotal * descuento_por_cliente

    subtotal_con_descuento = subtotal - descuento

    recargo_porcentaje =
      cond do
        mes == 12 or mes == 1 ->
          @recargo_diciembre_enero

        mes == 6 or mes == 7 ->
          @recargo_junio_julio

        true ->
          @recargo_normal
      end

    recargo = subtotal_con_descuento * recargo_porcentaje

    subtotal_hotel = subtotal_con_descuento + recargo

    {:ok, {subtotal_hotel, descuento, recargo}}
  end

  defp calcular_seguro(noches, seguro) do
    seguro = String.downcase(seguro)

    case seguro do
      "si" ->
        {:ok, @valor_seguro_noche * noches}

      "no" ->
        {:ok, 0.0}

      _ ->
        {:error, "La respuesta para el seguro debe ser si o no"}
    end
  end

  defp calcular_descuento_paquete(noches, subtotal_hotel, valor_seguro)
       when noches >= 3 do
    descuento = (subtotal_hotel + valor_seguro) * @descuento_paquete

    {:ok, descuento}
  end

  defp calcular_descuento_paquete(_noches, _subtotal_hotel, _valor_seguro) do
    {:ok, 0.0}
  end

  defp calcular_total(
         tarifa_vuelo,
         valor_maleta,
         subtotal_hotel,
         valor_seguro,
         descuento_paquete
       ) do
    total =
      tarifa_vuelo +
        valor_maleta +
        subtotal_hotel +
        valor_seguro -
        descuento_paquete

    {:ok, total}
  end

  defp mostrar_resultado(
         {:ok,
          {
            {tarifa_vuelo, valor_maleta, origen_maleta},
            {tarifa_noche, subtotal_hotel, descuento, recargo},
            {valor_seguro, descuento_paquete, total}
          }}
       ) do
    IO.puts("\n===== DETALLE DEL PAQUETE =====")

    IO.puts("Tarifa de vuelo: $#{formatear_dinero(tarifa_vuelo)}")

    IO.puts(
      "Maleta: $#{formatear_dinero(valor_maleta)} (#{formatear_origen_maleta(origen_maleta)})"
    )

    IO.puts("Tarifa por noche: $#{formatear_dinero(tarifa_noche)}")

    IO.puts("Subtotal hotel: $#{formatear_dinero(subtotal_hotel)}")

    IO.puts("Descuento cliente: $#{formatear_dinero(descuento)}")

    IO.puts("Recargo temporada: $#{formatear_dinero(recargo)}")

    IO.puts("Seguro: $#{formatear_dinero(valor_seguro)}")

    IO.puts("Descuento paquete: $#{formatear_dinero(descuento_paquete)}")

    IO.puts("--------------------------------")

    IO.puts("TOTAL: $#{formatear_dinero(total)}")
  end

  defp mostrar_resultado({:error, razon}) do
    IO.puts("\nERROR: #{razon}")
  end

  defp formatear_origen_maleta(:automatica) do
    "cobro automático por destino"
  end

  defp formatear_origen_maleta(:solicitada) do
    "solicitada por el cliente"
  end

  defp formatear_origen_maleta(:no_incluida) do
    "no solicitada"
  end

  defp formatear_dinero(valor) do
    :erlang.float_to_binary(valor, decimals: 2)
  end
end

PaqueteTuristico.main()
