defmodule ChatAppWeb.RoomChannel do
  use ChatAppWeb, :channel

  @impl true
  def join("room:lobby", %{"params" => %{"nickname" => nickname}}, socket) do
    socket = socket |> assign(:nickname, nickname)

    if authorized?(socket) do
        send(self(), :after_join)
        {:ok, nickname, socket}
      else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info(:after_join, socket) do
    nickname = socket.assigns.nickname
    broadcast(socket, "user:entered", %{nickname: nickname})
    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    nickname = socket.assigns.nickname
    broadcast(socket, "shout", %{nickname: nickname, message: payload})
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
