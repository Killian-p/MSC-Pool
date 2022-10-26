defmodule GothamWeb.CORS do
  use Corsica.Router,
    origins: "*",
    allow_credentials: true,
    max_age: 600,
    allow_methods: :all,
    allow_headers: :all,
    same_origins: false

  resource "/*"
end