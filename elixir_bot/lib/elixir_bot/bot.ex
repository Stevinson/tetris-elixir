defmodule ElixirBot.Bot do
    import Enum, only: [at: 2, count: 1, reverse: 1, find: 2, each: 2 ]
    # import Kernel, only: [abs: 1]
    @moduledoc """
    Bot to play tetris.
    """

    @doc """
    An extremely intelligent tetris bot.

    ElixirBot.Bot.play()
    """
    def play() do
        state = elem(ElixirBot.Requests.get_state(), 0)
        make_game_move(state, nil)
    end

    def make_game_move(state, previous_state) do
        # IO.inspect(state)
        board = state[:grid]
        if board != previous_state[:grid] do
            current_piece = state[:current]
            next_piece = state[:next]
            next_piece_pattern = ElixirBot.Shapes.shapes()[next_piece]
            current_piece_pattern = current_piece[:pattern]
            current_piece_x = current_piece[:x]
            current_piece_y = current_piece[:y]
            move = evaluate_moves(board, current_piece_pattern, next_piece_pattern)
            IO.puts("Best move:")
            IO.inspect(move)
            :timer.sleep(100)
            make_move(board, current_piece, move)
        end
        :timer.sleep(100)
        new_state = elem(ElixirBot.Requests.get_state(), 0)
        make_game_move(new_state, state)
    end

    @doc """
    Simulate every potential move, returning the one that both maximises
    the expected score and is a valid move.

    e.g. [0, 8, 1, 8]
         [current_rot, current_x, next_rot, next_x]
    """
    def evaluate_moves(board, piece, next_piece) do
        piece_width = Matrix.size(piece) |> elem(1)  
        next_piece_width = Matrix.size(next_piece) |> elem(1) 

        num = ElixirBot.ValidMove.board_width - piece_width
        num_next = ElixirBot.ValidMove.board_width - next_piece_width

        x_moves_current_piece = 0..num
        x_moves_next_piece = 0..num_next
        rotations = 0..3
        next_rotations = 0..3

        perms = permutations(rotations, x_moves_current_piece, next_rotations, x_moves_next_piece)

        Enum.max_by(perms, fn [current_rot, current_x, next_rot, next_x] ->  
            # IO.puts("testing #{current_rot} #{current_x} #{next_rot} #{next_x}")
            
            board_for_current = ElixirBot.ValidMove.place_piece_on_board(board, rotate_number_of_times(piece, current_rot), current_x)
            # board_for_next = ElixirBot.ValidMove.place_piece_on_board(board_for_current, rotate_number_of_times(next_piece, next_rot), next_x)

            ElixirBot.Scores.expected_score(board_for_current)

        end)
    end

    def test_eval() do
        board = [
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,1,1,1],
            [0,0,0,0,0,0,0,0,0,1]
            ]

            piece = [[1,0],[1,1],[1,0]]
            evaluate_moves(board, piece, piece)
    end

    def test_score do
        board = [
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,1,1],
            [0,0,0,0,0,0,0,1,1,0],
            [0,0,0,0,0,0,0,1,1,1],
            [0,0,0,0,0,0,0,0,0,1]
            ]

        board2 = [
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,1,1,1,1,1],
            [0,0,0,0,1,1,0,0,0,1]
            ]

        IO.puts(ElixirBot.Scores.average_height(board))
        IO.puts(ElixirBot.Scores.average_height(board2))
    end

    @doc """
    Carry out the actions to get the piece to format the desired board layout.
        For a current_board and a current_piece
        Do API request to move the piece into target_x, target_y and a target_pattern
        (the target rotated pattern)

    """
    def make_move(current_board, current_piece, move) do
        rotation = Enum.at(move, 0)
        IO.puts("Desired rotation #{rotation}")
        x_move = Enum.at(move, 1)
        IO.puts("Desired x_location #{x_move}")

        move_count = x_move - current_piece.x
        abs_move_count = Kernel.abs(move_count)

        ElixirBot.Requests.make_rotations(rotation)

        if move_count < 0 do
            Enum.each(0..abs_move_count, fn _i -> ElixirBot.Requests.move_left end)
        end

        if move_count > 0 do
            Enum.each(0..abs_move_count, fn _i -> ElixirBot.Requests.move_right end)
        end
    end

    @doc """
    Rotate a game piece by 90 degrees.
    """
    def rotate(pattern) do
        pattern
        |> List.zip
        |> Enum.map(&Tuple.to_list/1)
        |> Enum.map(&Enum.reverse/1)
    end

    @doc """
    Rotate a piece n times.
    """
    def rotate_number_of_times(pattern, n) do
        cond do
            n == 0 -> pattern
            true -> pat = rotate(pattern); rotate_number_of_times(pat, n-1)
        end
    end

    @doc """
    Return true if a proposed move, given a board layout and piece is possible.
    """
    def validate_move(board, piece, pos) do
        # TODO EdS: Validate not over the right hand side, if so, reject
        # TODO EdS: Validate not colliding with bottom, if so, return last position
    end

    @doc """
    
    """
    def permutations(a, b, c, d) do
        for x <- a, y <- b, z <- c, t <- d, do: [x, y, z, t]
    end
end
