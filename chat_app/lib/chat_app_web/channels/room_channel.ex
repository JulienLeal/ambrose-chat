defmodule ChatAppWeb.RoomChannel do
  use ChatAppWeb, :channel
  alias ChatAppWeb.Presence

  @impl true
  def join("room:lobby", params, socket) do
    nickname = Map.get(params, "nickname", "Guest##{unique_id_suffix(socket)}")
               |> String.trim()
               |> case do
                    "" -> "Guest##{unique_id_suffix(socket)}" # Ensure nickname is never empty
                    name -> name
                  end

    socket = socket |> assign(:nickname, nickname)

    if authorized?(socket) do
      # Track the user's presence
      # The key is the user's unique identifier (e.g., socket ID or user ID)
      # The value is a map of metadata (e.g., nickname, status)
      # Using socket.id as the key for tracking.
      Presence.track(socket, socket.id, %{
        nickname: nickname,
        online_at: inspect(System.system_time(:second)),
        status: "online"
      })

      send(self(), :after_join) # Trigger :after_join to send presence state
      # The initial list of presences will be sent via "presence_state" in :after_join
      {:ok, %{nickname: nickname, message: "Joined as #{nickname}"}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  defp unique_id_suffix(socket) do
    if socket.id, do: String.slice(socket.id, -6..-1), else: :rand.uniform(100_000) |> to_string()
  end

  @impl true
  def handle_info(:after_join, socket) do
    nickname = socket.assigns.nickname

    # Push the current presence state to the newly joined user
    push(socket, "presence_state", Presence.list(socket))

    # Broadcast user entered message (can be removed if presence_diff is preferred for join notifications)
    # For now, keeping it to show join message explicitly.
    # Presence.track itself will broadcast a diff for other clients.
    broadcast(socket, "user:entered", %{nickname: nickname, message: "#{nickname} has entered the room."})
    {:noreply, socket}
  end

  @impl true
  def handle_in("set_nickname", %{"nickname" => new_nickname_raw}, socket) do
    old_nickname = socket.assigns.nickname
    new_nickname = String.trim(new_nickname_raw)

    if new_nickname == "" do
      {:reply, {:error, %{reason: "Nickname cannot be empty."}}, socket}
    else
      socket = assign(socket, :nickname, new_nickname)
      broadcast(socket, "nickname_changed", %{old_nickname: old_nickname, new_nickname: new_nickname, message: "#{old_nickname} is now known as #{new_nickname}."})
      {:reply, {:ok, %{nickname: new_nickname, message: "Nickname changed to #{new_nickname}"}}, socket}
    end
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
  def handle_in("shout", %{"message" => message_body}, socket) do
    nickname = socket.assigns.nickname
    broadcast(socket, "shout", %{nickname: nickname, message: message_body, id: socket.id})
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
