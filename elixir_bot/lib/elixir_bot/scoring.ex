board = defmodule ElixirBot.Scores do
    @doc """
    Some scoring function for a board layout. It is a linear combination of 
    the different scoring metrics.
    """
    def expected_score(board) do
        complete_lines_weight = 1
        # holes_weight = -0.3
        av_height_weight = 0.3
        bumpiness_weight = -1

        score = (av_height_weight * max_height(board)) +
                # (holes_weight * holes(board)) +
                (complete_lines_weight * complete_lines(board)) +
                (bumpiness_weight * get_diffs(available_heights(board)))

        # random_number = :rand.uniform(10000)
    end

    @doc """
    The number of complete lines that will be removed. We want to maximise this.
    """
    def complete_lines(board) do
        board
        |> Enum.count(fn row -> 0 not in row end)
    end

    @doc """
    The sum of the absolute differences between adjacent columns. We want
    to minimise this.
    """
    # def bumpiness() do
    #     available_heights(board)
    # end

    @doc """
    The average height of all the columns. We want to minimise this.
    """
    def available_heights(board) do
        Enum.map(
          Enum.map(
            Matrix.transpose(board),  &Enum.take_while(&1, fn x->x==0 end)
          ), &Enum.count(&1)
        )
    end

    def average_height(board) do
        tmp = available_heights(board)
        opp_height = Enum.sum(tmp) / Enum.count(tmp)
        20 - opp_height
    end

    def max_height(board) do
        tmp = available_heights(board)
        Enum.min(tmp)
        # opp_height = Enum.sum(tmp) / Enum.count(tmp)
        # 20 - opp_height
    end

    def get_diffs(items) do
      items_a = items ++ [0]
      items_b = [0] ++ items
      tmp = Enum.map(Enum.zip(items_a, items_b), fn {a,b} -> abs(a-b) end)
      tmp2 = Enum.drop(Enum.drop(tmp, 1),-1)

      Enum.sum(tmp2) / Enum.count(tmp2)
    end

    @doc """
    The index of the first free space in a specified column.

    - If the column is full it will return 0
    - If the column is empty it will return height of the column
    """
    def available_height_of_column(board, column_ind) do
        Enum.count(Enum.take_while(Enum.at(board, column_ind), fn x -> x ==0 end))

    end

    @doc """
    The number of empty spaces with pieces above it. We want to minimise this.

    test: 
    ElixirBot.Scores.holes(board)
    """
    def holes(board) do
#        peaks = List.duplicate(ElixirBot.ValidMove.board_height, ElixirBot.ValidMove.board_width)
#        IO.inspect(peaks)
#
#        rows = Enum.to_list(0..ElixirBot.ValidMove.board_height-1)
#        cols = Enum.to_list(0..ElixirBot.ValidMove.board_width-1)
#
#        for row <- rows,
#            col <- cols do
#                board_val = board |> Enum.at(row) |> Enum.at(col)
#                peak_val = peaks |> Enum.at(col)
#                if board_val != 0 and peak_val == 20 do
#                    List.replace_at(peaks, col, row)
#                    IO.inspect(row)
#                    IO.puts("Should be change here")
#                end
#        end
#
#        num_holes = 0
#
#        for i <- cols,
#            b <- peaks |> Enum.at(i) do
#                if board |> Enum.at(b) |> Enum.at(i) == 0 do
#                    holes = holes + 1
#                end
#        end
#
#        IO.inspect(peaks)

        # peaks
        # |> Enum.with_index
        # |> Enump.map(fn i -> i)
    end
end