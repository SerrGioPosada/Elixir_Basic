defmodule Libro do
  @enforce_keys [:isbn]
  defstruct [:isbn, titulo: "", autor: "", ano: 0, genero: "", disponible: true]

  @ano_actual Date.utc_today().year

  def nuevo(attrs) when is_map(attrs) and map_size(attrs) > 0 do
    {:ok, struct(__MODULE__, attrs)}
  end

  def nuevo(_attrs), do: {:error, :atributos_invalidos}

  def prestar(%__MODULE__{disponible: true} = libro), do: {:ok, %{libro | disponible: false}}
  def prestar(%__MODULE__{disponible: false}), do: {:error, :no_disponible}

  def devolver(%__MODULE__{disponible: false} = libro), do: {:ok, %{libro | disponible: true}}
  def devolver(%__MODULE__{disponible: true}), do: {:error, :ya_disponible}

  def es_clasico(%__MODULE__{ano: ano})
      when ano < @ano_actual - 50, do: true

  def es_clasico(%__MODULE__{}), do: false
end

defmodule Usuario do
  @enforce_keys [:email, :id]
  defstruct [:email, :id, nombre: "", libros_prestados: [], prestamos: []]

  @maximo_prestamos 3

  def nuevo(attrs) when is_map(attrs) and map_size(attrs) > 0 do
    {:ok, struct(__MODULE__, attrs)}
  end

  def nuevo(_attrs), do: {:error, :atributos_invalidos}

  def puede_prestar?(%__MODULE__{libros_prestados: libros})
      when length(libros) < @maximo_prestamos, do: true

  def puede_prestar?(%__MODULE__{libros_prestados: libros})
      when length(libros) >= @maximo_prestamos, do: false

  def agregar_prestamo(
        %__MODULE__{libros_prestados: libros, prestamos: prestamos} = usuario,
        isbn,
        id_prestamo
      ) do
    if puede_prestar?(usuario) do
      {:ok, %{usuario | libros_prestados: [isbn | libros], prestamos: [id_prestamo | prestamos]}}
    else
      {:error, :maximo_prestamos_alcanzado}
    end
  end

  def quitar_prestamo(
        %__MODULE__{libros_prestados: libros} = usuario,
        isbn
      ) do
    {:ok, %{usuario | libros_prestados: List.delete(libros, isbn)}}
  end
end

defmodule Prestamo do
  @enforce_keys [:id, :libro_isbn, :usuario_id, :fecha_prestamo, :fecha_devolucion]
  defstruct [:id, :libro_isbn, :usuario_id, :fecha_prestamo, :fecha_devolucion]

  def nuevo(attrs) when is_map(attrs) and map_size(attrs) > 0 do
    {:ok, struct(__MODULE__, attrs)}
  end

  def nuevo(_attrs), do: {:error, :atributos_invalidos}

  def dias_retraso(%__MODULE__{fecha_devolucion: fecha_devolucion}) do
    hoy = Date.utc_today()

    # :gt es mayor que, :lt es menor que, :eq es igual a
    if Date.compare(hoy, fecha_devolucion) == :gt do
      Date.diff(hoy, fecha_devolucion)
    else
      0
    end
  end
end

defmodule BibliotecaStructs do
  def main do
    IO.puts("=== 1. CREANDO LIBROS Y USUARIOS ===")

    {:ok, l1} =
      Libro.nuevo(%{
        isbn: "978-1",
        titulo: "Cien años de soledad",
        autor: "García Márquez",
        ano: 1967,
        genero: "novela"
      })

    {:ok, l2} =
      Libro.nuevo(%{
        isbn: "978-2",
        titulo: "El Quijote",
        autor: "Cervantes",
        ano: 1605,
        genero: "novela"
      })

    {:ok, l3} =
      Libro.nuevo(%{
        isbn: "978-3",
        titulo: "Clean Code",
        autor: "Robert C. Martin",
        ano: 2008,
        genero: "tecnología"
      })

    libros = [l1, l2, l3]
    IO.inspect(libros, label: "Lista inicial de libros")

    {:ok, u1} = Usuario.nuevo(%{id: 1, nombre: "Ana", email: "ana@uniquindio.edu.co"})
    {:ok, u2} = Usuario.nuevo(%{id: 2, nombre: "Luis", email: "luis@uniquindio.edu.co"})

    usuarios = [u1, u2]
    IO.inspect(usuarios, label: "Lista inicial de usuarios")

    IO.puts("\n=== 2. PROBANDO FILTROS DE LIBROS ===")

    novelas = libros_por_genero(libros, "novela")
    IO.inspect(novelas, label: "Libros del género 'novela'")

    IO.puts("¿'Cien años de soledad' es clásico? #{Libro.es_clasico(l1)}")
    IO.puts("¿'Clean Code' es clásico? #{Libro.es_clasico(l3)}")

    IO.puts("\n=== 3. REALIZANDO UN PRÉSTAMO ===")

    case nuevo_prestamo(l1, u1, 101) do
      {:ok, libro_actualizado, usuario_actualizado, prestamo} ->
        IO.puts("¡Préstamo realizado con éxito!")
        IO.inspect(prestamo, label: "Detalles del préstamo")
        IO.inspect(usuario_actualizado, label: "Usuario después del préstamo")
        IO.inspect(libro_actualizado, label: "Libro prestado (ya no disponible)")

        IO.puts("\n=== 4. VERIFICANDO DISPONIBILIDAD Y RETRASOS ===")

        disponibles = libros_disponibles([libro_actualizado, l2, l3])
        IO.inspect(disponibles, label: "Libros disponibles restantes")

        # Ahora `prestamo` es un struct %Prestamo{} limpio, esto ya no dará warning de tipos
        dias = Prestamo.dias_retraso(prestamo)
        IO.puts("Días de retraso de este préstamo: #{dias}")

      {:error, razon} ->
        IO.puts("Error al realizar el préstamo: #{razon}")
    end
  end

  def nuevo_prestamo(libro, usuario, id_prestamo) do
    with {:ok, libro} <- Libro.prestar(libro),
         {:ok, usuario} <- Usuario.agregar_prestamo(usuario, libro.isbn, id_prestamo) do
      fecha_prestamo = Date.utc_today()
      fecha_devolucion = Date.add(fecha_prestamo, 14)

      {:ok, prestamo} =
        Prestamo.nuevo(%{
          id: id_prestamo,
          libro_isbn: libro.isbn,
          usuario_id: usuario.id,
          fecha_prestamo: fecha_prestamo,
          fecha_devolucion: fecha_devolucion
        })

      {:ok, libro, usuario, prestamo}
    else
      {:error, :no_disponible} -> {:error, :libro_no_disponible}
      {:error, :maximo_prestamos_alcanzado} -> {:error, :usuario_no_puede_prestar}
    end
  end

  def libros_disponibles(libros) do
    libros
    |> Enum.filter(& &1.disponible)
  end

  def libros_por_genero(libros, genero) do
    libros
    |> Enum.filter(&(&1.genero == genero))
  end

  def usuarios_prestamos_vencidos(usuarios) do
    usuarios
    |> Enum.filter(fn %Usuario{prestamos: prestamos} ->
      Enum.any?(prestamos, fn %Prestamo{} = prestamo ->
        Prestamo.dias_retraso(prestamo) > 0
      end)
    end)
  end

  def mas_prestados(prestamos) do
    prestamos
    |> Enum.reduce(%{}, fn %Prestamo{libro_isbn: isbn}, acc ->
      Map.update(acc, isbn, 1, &(&1 + 1))
    end)
    |> Enum.sort_by(fn {_isbn, count} -> -count end)
    |> Enum.take(5)
  end

  def quitar_prestamo_usuario(usuario, id_prestamo) do
    buscar_libro_por_prestamo(usuario.prestamos, id_prestamo)
    |> case do
      {:error, :prestamo_no_encontrado} ->
        {:error, :prestamo_no_encontrado}

      isbn ->
        usuario = Usuario.quitar_prestamo(usuario, isbn)
        {:ok, usuario}
    end
  end

  def buscar_libro_por_prestamo(prestamos, id_prestamo) do
    case buscar_prestamo_por_id(prestamos, id_prestamo) do
      nil -> {:error, :prestamo_no_encontrado}
      %Prestamo{libro_isbn: isbn} -> isbn
    end
  end

  def buscar_prestamo_por_id(prestamos, id) do
    Enum.find(prestamos, &(&1.id == id))
  end

  def buscar_libro_por_isbn(libros, isbn) do
    Enum.find(libros, &(&1.isbn == isbn))
  end
end

BibliotecaStructs.main()
