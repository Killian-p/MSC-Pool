defmodule Gotham.Sessions.Session do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sessions" do
    field :xrsf_token, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:xrsf_token, :user_id])
    |> validate_required([:xrsf_token, :user_id])
  end
end
