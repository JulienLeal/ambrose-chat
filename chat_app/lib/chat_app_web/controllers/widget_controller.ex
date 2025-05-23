defmodule ChatAppWeb.WidgetController do
  use ChatAppWeb, :controller

  def init(conn, _params) do
    conn
    |> put_layout({ChatAppWeb.LayoutView, :widget})
    |> render("chat.html")
  end
end
