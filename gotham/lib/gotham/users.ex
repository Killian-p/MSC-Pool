defmodule Gotham.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Gotham.Repo

  alias Gotham.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    Repo.get!(User, id)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def update_user_roles(%User{} = user, attrs) do
    user
    |> User.changeset_user_roles(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def get_user_by_mail_and_username(username, email) do
    Repo.all(from user in "users", where: user.username == ^username and user.email == ^email, select: [:email, :username, :id])
  end

  def get_user_by_username(username) do
    Repo.all(from user in "users", where: user.username == ^username, select: [:email, :username, :id])
  end

  def get_user_by_mail(email) do
    Repo.all(from user in "users", where: user.email == ^email, select: [:email, :username, :id])
  end

  def get_user_by_mail_and_password(email, password) do
    Repo.one(from user in "users", where: user.email == ^email and user.password == ^password, select: [:email, :username, :id, :password, :roles])
  end
end
# user.username == ^username and 
# |> Enum.into(%{})