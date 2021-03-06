defmodule CurtainWith.House do
  use CurtainWith.Web, :model

  schema "houses" do
    field :name, :string
    field :book, :map

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :book])
    |> validate_required([:name, :book])
    |> unique_constraint(:name)
  end

  @doc """
  Returns a single House matching the provided `name` exactly.
  """
  def find_by_name(name), do: find_by_name(__MODULE__, name)
  def find_by_name(query, name) do
    from house in query,
      where: house.name == ^name,
      limit: 1
  end
end
