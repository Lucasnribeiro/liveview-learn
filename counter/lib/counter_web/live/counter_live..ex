defmodule CounterWeb.CounterLive do
  use CounterWeb, :live_view

  @topic "live"

  def mount(_params, _session, socket) do
    CounterWeb.Endpoint.subscribe(@topic) # subscribe to the channel
    {:ok, assign(socket, :count, 0)}
  end

  def handle_event("inc", _, socket) do
    new_state = update(socket, :count, &(&1 + 1))
    CounterWeb.Endpoint.broadcast_from(self(), @topic, "inc", new_state.assigns)
    {:noreply, update(socket, :count, &(&1 + 1))}
  end

  def handle_event("dec", _, socket) do
    new_state = update(socket, :count, &(&1 - 1))
    CounterWeb.Endpoint.broadcast_from(self(), @topic, "dec", new_state.assigns)
    {:noreply, update(socket, :count, &(&1 - 1))}
  end

  def handle_info(msg, socket) do
    {:noreply, assign(socket, count: msg.payload.count)}
  end

  def render(assigns) do
    ~H"""
    <div class="text-center">
      <h1 class="text-4xl font-bold text-center"> Counter: <%= @count %> </h1>
      <.button phx-click="dec" class="w-20 bg-red-500 hover:bg-red-600">-</.button>
      <.button phx-click="inc" class="w-20 bg-green-500 hover:bg-green-600">+</.button>
    </div>
    """
  end
end
