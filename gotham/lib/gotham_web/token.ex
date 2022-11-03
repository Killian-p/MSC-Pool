defmodule GothamWeb.Token do
  use Joken.Config

  alias Gotham.Sessions

  def generate_xrsf() do
    alphabet = Enum.to_list(?a..?z) ++ Enum.to_list(?0..?9) ++ Enum.to_list(?A..?Z)

    data = Enum.take_random(alphabet, 50)
    List.to_string(data)
  end

  def create_jwt_token(user) do
    xrsf_token = generate_xrsf()

    session = Sessions.get_sessions_by_user_id(user.id)
    cond do
      # create session
      is_nil(session) ->
        tmp = Sessions.create_session(%{"xrsf_token" => xrsf_token, "user_id" => user.id})
      # update session
      true ->
        session = Sessions.update_session(Sessions.get_session!(session.id), %{"user_id" => user.id, "xrsf_token" => xrsf_token})
    end

    extra_claims = %{
      "user_id" => user.id,
      "user_role" => user.roles,
      "xrsf_token" => xrsf_token,
      "exp" => DateTime.utc_now |> DateTime.add(30 * 24 * 60 * 60, :second) |> DateTime.to_unix()
    }
    jwt_token = GothamWeb.Token.generate_and_sign!(extra_claims)
  end

  def is_token_valid(token) do
   # extra_claims = %{
      #   "user_id" => user.id,
      #   "user_role" => user.roles,
      #   "xrsf_token" => Bcrypt.Base.hash_password(user.password, Bcrypt.Base.gen_salt(12, true)),
      #   "exp" => DateTime.utc_now |> DateTime.add(30 * 24 * 60 * 60, :second) |> DateTime.to_unix()
      # }
      # jwt_token = GothamWeb.Token.generate_and_sign!(extra_claims)
      {:ok, claims} = GothamWeb.Token.verify_and_validate(token)
      # cond do
        
  end 
end
