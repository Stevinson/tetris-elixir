defmodule ElixirBot.ValidMove do
    import Enum, only: [at: 2, count: 1, reverse: 1, each: 2, map: 2, sum: 1]
    @board_width 10
    @board_height 20

    @doc """
    Return the resultant board given a board layout, a piece and an X-pos to place the piece.

    test:
        ElixirBot.ValidMove.place_piece_on_board(ElixirBot.ValidMove.shape_in_board(shapes.line, 0, 9) , shapes.ell, 0)
    """
    def place_piece_on_board(board, shape, xposition) do
        yposition = get_floor_y(board, shape, xposition)
        cond do
            yposition == nil -> board
            true -> Matrix.add(board, shape_in_board(shape, xposition, yposition))
        end
    end

    @doc """
    Given a shape and an X-Y-position return a new board with the shape in it.
    """
    def shape_in_board(shape, xposition, yposition) do
        # X-position
        shape_width = Enum.max(Enum.map(shape, &Enum.count/1))
        right_pad_count = @board_width - xposition
        
        # Y-position
        shape_height = Enum.count(shape)
        bottom_fill_count = @board_height - yposition 

        cond do
            right_pad_count < shape_width -> nil
            bottom_fill_count < shape_height -> nil
            true ->
                right_pad_count = right_pad_count - shape_width
                bottom_fill_count = bottom_fill_count - shape_height
                

                left_padding = generate_horizontal_padding(xposition)
                right_padding = generate_horizontal_padding(right_pad_count)


                top_fill = generate_vertical_padding(yposition, @board_width)
                bottom_fill = generate_vertical_padding(bottom_fill_count, @board_width)

                # Fill the space around the shape to get the board
                top_fill ++ Enum.map(shape, fn x -> left_padding ++ x ++ right_padding end) ++ bottom_fill
        end
    end

    defp _state do
        state = ElixirBot.Requests.get_state()
        
        elem(state, 0).grid
        elem(state, 0).current
        elem(state, 0).current.pattern
        elem(state, 0).current.x
        elem(state, 0).current.y

        # IO.inspect(state)
    end

    defp matrix_sum(matrix) do
        Enum.sum(Enum.map(matrix, &Enum.sum/1))
    end

    defp generate_horizontal_padding(count) do
        # Return a list of zeros, of lenght count
        if count == 0 do
            []
        else
            Enum.map(Enum.to_list(1..count), fn _x -> 0 end)
        end

    end

    defp generate_vertical_padding(count, width) do
        # Return a list of zeros, of lenght count
        
        if count == 0 do
            []
        else
            Matrix.new(count, width, 0)
        end

    end

    defp get_shape_width(shape) do
        Enum.count(Enum.at(shape, 0))
    end

    defp get_shape_height(shape) do
        Enum.count(shape)
    end

    defp intersects(board_a, board_b) do
        # return true if both boards share non-zero positions
        matrix_sum(Matrix.emult(board_a, board_b)) > 0
        
    end

    defp get_floor_y(board, shape, xposition) do
        # get the max value of y that yields a shape being at the floor of a board
        # aka: the lowest position w/o intersecting the existing board.
        get_floor_y(board, shape, xposition, 0)
    end
    
    defp get_floor_y(board, shape, xposition, yposition) do
        # shapes = ElixirBot.Shapes.shapes()
        # ElixirBot.ValidMove.get_floor_y(Matrix.new(10,10,1), shapes.ell, 0)

        shape_height = get_shape_height(shape)
        bshape = shape_in_board(shape, xposition, yposition)

        # IO.puts("STB yposition #{yposition} ")
        # IO.inspect(bshape)
        # if bshape == nil do
            # nil
        # end


        cond do
            yposition >= @board_height - shape_height + 1-> @board_height - shape_height
            bshape == nil -> nil
            board == nil -> nil
            true -> 
                if not intersects(board, bshape) do
                    get_floor_y(board, shape, xposition, yposition + 1)
                else
                    if yposition == 0 do
                        nil
                    else
                        yposition - 1
                    end
                end
        end

    end

    # TODO JUAN: We need to return how many lines a move returned

    # Make the board width and height available in other modules
    def board_width do
        @board_width
    end

    def board_height do
        @board_height
    end
end
