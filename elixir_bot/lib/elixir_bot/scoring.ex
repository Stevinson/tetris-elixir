defmodule ElixirBot.Scores do
    @doc """
    Some scoring function for a board layout. It is a linear combination of 
    the different scoring metrics.
    """
    def expected_score(board) do
        complete_lines_weight = 0.9
        holes_weight = -0.3

        score = (complete_lines_weight * complete_lines(board)) + 
                (holes_weight * holes(board))
    end
    
    @doc """
    The number of complete lines that will be removed. We want to maximise this.
    """
    def complete_lines(board) do
        board
        |> Enum.count(fn row -> 0 not in row end)
    end

    @doc """
    Some board spaces are more valuable than others.
    """
    def weighted_spaces() do
    end

    @doc """
    The sum of the absolute differences between adjacent columns. We want
    to minimise this.
    """
    def bumpiness() do
    end

    @doc """
    The number of empty spaces with pieces above it. We want to minimise this.
    """
    def holes(board) do
    end

    @doc """
    The average height of all the columns. We want to minimise this.
    """
    def average_height(board) do
        cols = 1..length(Enum.at(board, 0))
        
        cols
        |> IO.puts
        # sum = cols
        # |> Enum.map(fn col_ind -> length() - index_height_of_column(board, col_ind) end)
        # |> Enum.sum

        # sum / length(Enum.at(board, 0))
    end
end