defmodule Pokemon do
  @enforce_keys [:nombre, :nivel]
  defstruct [:nombre, :nivel, movimientos: []]
  @max_movimientos 4

  def nuevo(nombre, nivel) when nivel > 0 and nivel <= 100 do
    {:ok, %__MODULE__{nombre: nombre, nivel: nivel}}
  end

  def nuevo(_nombre, _nivel), do: {:error, :nivel_invalido}

  def aprender_movimiento(%__MODULE__{movimientos: movimientos} = pokemon, movimiento) do
    cond do
      conoce_movimiento?(pokemon, movimiento) -> {:error, :ya_lo_conoce}
      length(movimientos) >= @max_movimientos -> {:error, :movimientos_llenos}
      true -> {:ok, %{pokemon | movimientos: [movimiento | movimientos]}}
    end
  end

  def olvidar_movimiento(%__MODULE__{movimientos: movimientos} = pokemon, movimiento) do
    {:ok, %{pokemon | movimientos: List.delete(movimientos, movimiento)}}
  end

  def conoce_movimiento?(%__MODULE__{movimientos: movimientos}, movimiento),
    do: Enum.member?(movimientos, movimiento)
end

defmodule Pokedex do
  def main do
    # Inicializar
    pokemones = %{}

    # Registrar Pokémon
    {:ok, pokemones} = registrar_pokemon(pokemones, 25, "Pikachu", 12)
    {:ok, pokemones} = registrar_pokemon(pokemones, 6, "Charizard", 36)
    {:ok, pokemones} = registrar_pokemon(pokemones, 9, "Blastoise", 34)

    # Intentar registrar duplicado
    case registrar_pokemon(pokemones, 25, "Otro Pikachu", 5) do
      {:error, :numero_duplicado} ->
        IO.puts("No se puede registrar: numero de Pokedex duplicado")

      {:ok, _} ->
        IO.puts("Pokemon registrado")
    end

    # Enseñar movimientos
    {:ok, pokemones} = aprender_movimiento(pokemones, 25, "Impactrueno")
    {:ok, pokemones} = aprender_movimiento(pokemones, 25, "Ataque Rapido")
    {:ok, pokemones} = aprender_movimiento(pokemones, 6, "Lanzallamas")

    # Intentar enseñar un movimiento que ya conoce
    case aprender_movimiento(pokemones, 25, "Impactrueno") do
      {:error, :ya_lo_conoce} ->
        IO.puts("Ese Pokemon ya conoce el movimiento")

      {:ok, _} ->
        IO.puts("Movimiento aprendido")
    end

    # Intentar enseñar un quinto movimiento
    {:ok, pokemones} = aprender_movimiento(pokemones, 25, "Cola Ferrea")
    {:ok, pokemones} = aprender_movimiento(pokemones, 25, "Rayo")

    case aprender_movimiento(pokemones, 25, "Placaje") do
      {:error, :movimientos_llenos} ->
        IO.puts("El Pokemon ya conoce cuatro movimientos, debe olvidar uno primero")

      {:ok, _} ->
        IO.puts("Movimiento aprendido")
    end

    # Mostrar información
    case obtener_pokemon(pokemones, 25) do
      {:ok, pokemon} ->
        IO.puts("\n=== Pokemon 25 ===")
        IO.inspect(pokemon)

      {:error, _} ->
        IO.puts("Pokemon no encontrado")
    end

    # Estadísticas
    stats = obtener_estadisticas(pokemones)
    IO.puts("\n=== Estadisticas ===")
    IO.inspect(stats)

    # Listar los Pokémon que conocen un movimiento
    IO.puts("\n=== Pokemon que conocen Impactrueno ===")
    electricos = pokemones_con_movimiento(pokemones, "Impactrueno")
    Enum.each(electricos, &IO.puts(&1.nombre))

    # Actualizar Pokémon
    {:ok, pokemones} = actualizar_pokemon(pokemones, 25, "Pikachu", 13)

    # Liberar Pokémon
    {:ok, pokemones} = liberar_pokemon(pokemones, 9)

    # Mostrar todos
    IO.inspect(listar_pokemones(pokemones))
  end

  def registrar_pokemon(pokemones, numero, nombre, nivel) do
    case Pokemon.nuevo(nombre, nivel) do
      {:ok, nuevo_pokemon} ->
        if Map.has_key?(pokemones, numero) do
          # Si el número ya existe, no se agrega y se retorna un error
          {:error, :numero_duplicado}
        else
          # Retorna un nuevo mapa con el Pokémon agregado
          {:ok, Map.put(pokemones, numero, nuevo_pokemon)}
        end

      {:error, razon} ->
        {:error, razon}
    end
  end

  def obtener_pokemon(pokemones, numero) do
    case Map.get(pokemones, numero) do
      nil -> {:error, :no_encontrado}
      pokemon -> {:ok, pokemon}
    end
  end

  def actualizar_pokemon(pokemones, numero, nombre, nivel) do
    case Map.get(pokemones, numero) do
      nil ->
        {:error, :no_encontrado}

      pokemon ->
        actualizado = %{pokemon | nombre: nombre, nivel: nivel}
        # Retorna un nuevo mapa con el Pokémon actualizado
        {:ok, Map.put(pokemones, numero, actualizado)}
    end
  end

  def liberar_pokemon(pokemones, numero) do
    if Map.has_key?(pokemones, numero) do
      # Retorna un nuevo mapa sin el Pokémon liberado
      {:ok, Map.delete(pokemones, numero)}
    else
      {:error, :no_encontrado}
    end
  end

  def aprender_movimiento(pokemones, numero, movimiento) do
    case Map.get(pokemones, numero) do
      nil ->
        {:error, :no_encontrado}

      pokemon ->
        case Pokemon.aprender_movimiento(pokemon, movimiento) do
          {:ok, actualizado} ->
            # Retorna un nuevo mapa con el Pokémon actualizado
            {:ok, Map.put(pokemones, numero, actualizado)}

          {:error, razon} ->
            {:error, razon}
        end
    end
  end

  def olvidar_movimiento(pokemones, numero, movimiento) do
    case Map.get(pokemones, numero) do
      nil ->
        {:error, :no_encontrado}

      pokemon ->
        # Pokemon.olvidar_movimiento/2 siempre retorna {:ok, ...}, así que en lugar de un
        # `case` de una sola rama se usa pattern matching directo sobre el resultado
        {:ok, actualizado} = Pokemon.olvidar_movimiento(pokemon, movimiento)
        # Retorna un nuevo mapa con el Pokémon actualizado
        {:ok, Map.put(pokemones, numero, actualizado)}
    end
  end

  def listar_pokemones(pokemones), do: Map.values(pokemones)

  # Devuelve la lista de Pokémon que conoce un movimiento específico
  def pokemones_con_movimiento(pokemones, movimiento) do
    pokemones
    |> Map.values()
    |> Enum.filter(&Pokemon.conoce_movimiento?(&1, movimiento))
  end

  # Devuelve estadísticas básicas de la Pokédex
  def obtener_estadisticas(pokemones) do
    %{
      total: map_size(pokemones),
      nivel_promedio: calcular_nivel_promedio(pokemones)
    }
  end

  defp calcular_nivel_promedio(pokemones) when map_size(pokemones) == 0, do: 0

  defp calcular_nivel_promedio(pokemones) do
    niveles = pokemones |> Map.values() |> Enum.map(& &1.nivel)
    Enum.sum(niveles) / length(niveles)
  end
end

Pokedex.main()
