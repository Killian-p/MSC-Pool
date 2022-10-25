defmodule Gothamcityhall.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :firstname, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:firstname, :email])
    |> validate_required([:firstname, :email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
  end
end
