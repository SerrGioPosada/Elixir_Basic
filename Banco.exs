defmodule Banco do
  @pin_correcto "0482"
  @saldo_disponible 450_000
  @limite_por_retiro 600_000

  def main do
    pin = Util.leer("ingrese su pin: ", :string)
    tipo_de_cuenta = Util.leer("ingrese el tipo de cuenta: ", :string)
    monto = Util.leer("ingrese el monto a retirar: ", :integer)

    retirar(pin, tipo_de_cuenta, monto)
    |> generar_mensaje()
    |> Util.imprimir_mensaje()
  end

  def retirar(pin, tipo_de_cuenta, monto) do
    with {:ok, _pin} <- validar_pin(pin),
         {:ok, tipo_cuenta} <- validar_cuenta(tipo_de_cuenta),
         {:ok, monto} <- validar_monto(monto),
         {:ok, comision} <- calcular_comision(tipo_cuenta, monto),
         {:ok, monto} <- validar_saldo(monto, comision) do
      saldo_restante = @saldo_disponible - monto - comision
      billetes = calcular_billetes(monto)
      {:ok, {monto, comision, saldo_restante, billetes}}
    else
      {:error, motivo} -> {:error, motivo}
    end
  end

  def validar_pin(pin) do
    if String.length(pin) == 4 and pin == @pin_correcto do
      {:ok, pin}
    else
      {:error, "PIN incorrecto"}
    end
  end

  def validar_cuenta("ahorros"), do: {:ok, :ahorros}
  def validar_cuenta("corriente"), do: {:ok, :corriente}
  def validar_cuenta(_), do: {:error, "tipo de cuenta invalido"}

  def validar_monto(monto) do
    case monto do
      monto when monto <= 0 ->
        {:error, "el monto debe ser mayor que cero"}

      monto when div(monto, 10_000) * 10_000 != monto ->
        {:error, "el monto debe ser multiplo de 10000"}

      monto when monto > @limite_por_retiro ->
        {:error, "el monto supera el limite por retiro"}

      monto ->
        {:ok, monto}
    end
  end

  def validar_saldo(monto, comision) do
    if monto + comision <= @saldo_disponible do
      {:ok, monto}
    else
      {:error, "saldo no disponible. "}
    end
  end

  def calcular_comision(:ahorros, monto) when monto <= 200_000 do
    {:ok, 0}
  end

  def calcular_comision(:ahorros, monto) when monto > 200_000 do
    {:ok, 2_500}
  end

  def calcular_comision(:corriente, _monto) do
    {:ok, 4_000}
  end

  def calcular_billetes(monto) do
    billetes_de_50 = div(monto, 50_000)
    restante = monto - billetes_de_50 * 50_000

    billetes_de_20 = div(restante, 20_000)
    restante = restante - billetes_de_20 * 20_000

    billetes_de_10 = div(restante, 10_000)

    {billetes_de_50, billetes_de_20, billetes_de_10}
  end

  def generar_mensaje(
        {:ok, {monto, comision, saldo_restante, {billetes_de_50, billetes_de_20, billetes_de_10}}}
      ) do
    "Retiro exitoso.\nMonto retirado: $#{monto}\nComisión: $#{comision}\nSaldo restante: $#{saldo_restante}\nBilletes de 50.000: #{billetes_de_50}\nBilletes de 20.000: #{billetes_de_20}\nBilletes de 10.000: #{billetes_de_10}"
  end

  def generar_mensaje({:error, motivo}) do
    "Error: #{motivo}"
  end
end

Banco.main()
