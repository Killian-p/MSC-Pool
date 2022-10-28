defmodule Gotham.Clocks.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clocks" do
    field :status, :boolean, default: true
    field :time, :naive_datetime
    field :user, :id

    timestamps()
  end

  @doc false
  def createset(clock, attrs) do
    clock
    |> cast(attrs, [:time, :status, :user])
    |> validate_required([:time, :status, :user])
  end

  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:time, :status])
    |> validate_required([:time, :status])
  end
end
