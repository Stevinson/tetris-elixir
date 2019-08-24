defmodule ElixirBot.Shapes do
    def shapes() do
        %{
                :square => [
                    [1, 1],
                    [1, 1]
                ],
                :line => [
                    [1, 1, 1, 1]
                ],
                :ell => [
                    [1, 1],
                    [1, 0],
                    [1, 0]
                ],
                :elle => [
                    [1, 1],
                    [0, 1],
                    [0, 1] 
                ],
                :sqwaz => [
                    [1, 0],
                    [1, 1],
                    [0, 1]
                ],
                :sqwazle => [
                    [0, 1],
                    [1, 1],
                    [1, 0]
                ],
                :tee => [
                    [1, 0],
                    [1, 1],
                    [1, 0]
                ]
        }
    end
end