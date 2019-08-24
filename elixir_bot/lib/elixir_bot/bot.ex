defmodule ElixirBot.Bot do
    @moduledoc """
    Bot to play tetris.
    ElixirBot.Bot.play()
    """
    import Enum, only: [at: 2, count: 1, reverse: 1, find: 2]

    @doc """
    An extremely intelligent tetris bot.
    """
    def play() do
        state = elem(ElixirBot.Requests.get_state(), 0)
        
        # TODO EdS: Instead of accessing each individually here, marshall into struct
        board = state[:grid]
        current_piece = state[:current]
        next_piece = state[:next]
        current_piece_pattern = current_piece[:pattern]
        current_piece_x = current_piece[:x]
        current_piece_y = current_piece[:y]

        # board = Matrex.new(elem(state, 0))

        # move = evaluate_moves(board)
        # make_move(current_board, current_piece, target_x, target_y, target_pattern)
    end

    @doc """
    Simulate every potential move, returning the one that both maximises
    the expected score and is a valid move.
    """
    def evaluate_moves(board, piece) do    
    for rotation <- [1, 2, 3, 4], 
        movement <- ["Foo", "bar", "baz"] do 
            piece = rotate(piece)
            
    end

        # for every rotation of piece
            # for every position of piece
                # validate_move()
                # expected_score(move)

        # TODO EdS: If line completed remove
    end

    @doc """
    Return true if a proposed move, given a board layout and piece is possible.
    """
    def validate_move(board, piece, pos) do
    end

    @doc """
    TODO EdS:
    """
    def simulate() do
        # TODO EdS: Remove any complete rows

        # TODO EdS: Need to simulate the best place for the next piece
    end

    def add_to_board do 
        # TODO EdS:
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
    The index of the first free space in a specified column.

    - If the column is full it will return 0
    - If the column is empty it will return height of the column
    """
    def index_height_of_column(board, column_ind) do      
        board
        |> Enum.with_index
        |> Enum.reduce_while(length(Enum.at(board, 0)), fn ({row, row_ind}), acc -> 
            if Enum.at(row, column_ind) > 0, do: {:halt, row_ind}, else: {:cont, acc}
        end)
    end
end