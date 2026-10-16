defmodule DivisionSucesiva do
  def main do
    IO.inspect(division(20, 5))
  end

  def division(_, 0), do: {:error, "division por cero"}
  def division(dividendo, divisor), do: division_tail(dividendo, divisor, 0)

  def division_tail(dividendo, divisor, acc) when dividendo < divisor, do: {acc, dividendo}
  def division_tail(dividendo, divisor, acc), do: division_tail(dividendo - divisor, divisor, acc+1)

end

DivisionSucesiva.main()
