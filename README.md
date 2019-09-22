# Tetris

Bot built in Elixir to play tetris as part of hackday.

## Setup
 
After cloning the repo run the following commands to install and activate the environment:
  
```
conda env create
conda activate tetris
cd app
python api.py # start the tetris server
```

## Endpoints

There are two endpoints:

### POST \action

You can send an action to this endpoint as an int from 1 - 4:

1 - LEFT
2 - RIGHT
3 - DOWN
4 - ROTATE

### GET \state 

Hitting this endpoint will return a JSON object containing the following:

grid:

A 2d array describing the grid. a zero value in any elemnnt indicates that 
position is empty. Any other number indicates it is filled.

current: 

a json object describing the current piece and its position

{
    pattern: the current piece pattern as a 2d array
    x: the top left x coordinate
    y: the bottom left y coordinate
}

## Elixir bot

First install elixir [here](https://elixir-lang.org/install.html#macos)

`mix deps.get` to fetch and build dependencies if you add to `mix.exs`

`iex -S mix` to enter application interactively i.e. compile and drop inside iex session with code loaded.

When the tetris server ir running, `ElixirBot.Bot.play()` will start the bot playing.