defmodule SumarPrimos do
    def main do
        IO.inspect(sumar_primos([4, 7, 12, 19, 23, 30, 31, 42, 47, 51]))
        IO.inspect(sumar_primos([3, 10, 17, 22, 29, 34, 41, 49, 53, 60]))
    end

    def sumar_primos(lista), do: sumar_primos_tail(lista, 0)

    def sumar_primos_tail([], acc), do: acc
    def sumar_primos_tail([head | tail], acc), do: sumar_primos_tail(tail, primo(head) + acc)

    def primo(p) when p < 2, do: p
    def primo(p), do: primo_tail(p, 2)

    def primo_tail(p, n) when n < p do
      if rem(p, n) == 0 do
        0
    else
        primo_tail(p, n+1)
    end
    end

    def primo_tail(p, p), do: p

end
SumarPrimos.main()
