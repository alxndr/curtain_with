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
end
