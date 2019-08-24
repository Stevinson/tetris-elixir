defmodule ElixirBot.Requests do
  @moduledoc """
  Functions related to performing HTTP requests.
  """

  @doc """
  Carry out the actions to get the piece to format he desired board layout.
  """
  def make_move(current_board, current_piece, target_x, target_y, target_pattern) do
      if current_piece.pattern -- target_pattern.pattern != [] do
          ElixirBot.Bot.rotate(target_pattern.pattern)
      end
      if current_piece.pattern -- target_pattern.pattern != [] do
          ElixirBot.Bot.rotate(target_pattern.pattern)
      end
      if current_piece.pattern -- target_pattern.pattern != [] do
          ElixirBot.Bot.rotate(target_pattern.pattern)
      end

      move_count = target_x - current_piece.x
      abs_move_count = Kernel.abs(move_count)

      if move_count < 0 do
          Enum.each(0..abs_move_count, fn _i -> ElixirBot.Requests.move_left end)
      end

      if move_count > 0 do
          Enum.each(0..abs_move_count, fn _i -> ElixirBot.Requests.move_right end)
      end
  end

  @doc """
  Get the game state, this comprises of:
  - grid: The current 10*20 matrix of the board
  - next: The shape of the next piece
  - current: The current piece
      - pattern: Mtarix representation of the moveable piece.
      - x: The x coordinate of the top-left corner of the piece
      - y: The y coordinate of the top-left corner of the piece
  """
  def get_state() do
    url = "http://127.0.0.1:5000"
    state_url = [url, "/state"]
    state = get(state_url, [{"content-type", "aplication/json"}])
    # TODO EdS: Put state map into State struct
    # states = Poison.decode!(~s(state), as: [%State{}])
  end

  # TODO EdS: Note that if the game is not in play then there is no current piece returned and things will go heywire

  def make_rotation() do
    post_action(4)
  end

  def move_left() do
    post_action(1)
  end

  def move_right() do
    post_action(2)
  end

  def move_down() do
    post_action(3)
  end

    @doc """
    Perform an action, where the possibilities are:
      1. left
      2. right
      3. down
      4. rotate
    """
    def post_action(action) do
      url = "http://127.0.0.1:5000"
      action_url = [url, "/action"]
      body = Poison.encode!(%{
        action: action
      })
      post(action_url, body, [{"content-type", "aplication/json"}])
    end

    @doc """
    Perform a GET request.
    """
    def get(url, headers \\ []) do
      url
      |> HTTPoison.get(headers)
      |> case do
        {:ok, %{status_code: code, body: raw_body}} -> {code, raw_body}
        {:error, %{reason: reason}} -> {:error, reason}
      end
      |> (fn {ok, body} -> 
            body
            |> Poison.decode([keys: :atoms])
            |> case do
                {:ok, parsed} -> {parsed}
                _ -> {:error, body}
            end
          end).()
    end

    @doc """
    Perform a POST request.
    """
    def post(url, req_body, headers \\ []) do
      url
      |> HTTPoison.post(req_body, headers, [])
      |> case do
        {:ok, %{status_code: code, body: body}} -> {code, body}
        {:error, %{reason: reason}} -> {:error, reason, []}
      end
      |> (fn {code, body} -> 
            body
            |> Poison.decode([keys: :atoms])
            |> case do
                {:ok, parsed} -> {parsed}
                _ -> {:error, body}
            end
          end).()
    end
end