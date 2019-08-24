Tetris 1.0,0


  |                   ,---+---,          |
  |                   | . | . |          |
  |                   +---+ . |          |
  |                   | . . . |          |
  |                   +---+---+          |
  |                   | . . . |          |
  |                   | . . . |          |
  |                   | . . . |          |
  |                   +---+---'          | 
  |                   | . |              |
  |                   | . |              |
  |                   | . |              |
  |                   | . '---,          |
  |                   | . . . |          |
  |                   +---+---+          |
  |                   | . . . |          |
  |       _____ _____ _____ _____        |
  |      |   __|  _  |     |   __|       |
  |      |  |  |     | | | |   __|       |
  |      |_____|__|__|_|_|_|_____|       |
  |       _____ _____ _____ _____        |
  |      |     |  |  |   __| __  |       |
  |      |  |  |  |  |   __|    -|       |
  |      |_____|\___/|_____|__|__|       |
  |                                      |
  |                   | . . . |          |
  |                   +---+---+          |
  |                   | . . . |          |
  |               ,---' . ,---'       ,--+
  |               | . . . |           | .|
  |               '---+---+           | .+
  |                   | . |           | .|
  |                   | . |   ,-------+ .+
  |                   | . |   | . . . | .|
  |                   | . '---+ . . . + .+
  |                   | . . . | . . . | .|
  +-------------------+---+---+---+---+--+
  
Hello and welcome to the Eigen Tetris readme. Here you can find all the 
information you need about how to get Tetris up and running on your machine. 
The first thing you're going to need is a little bit of space, so clear an area 
around you around 2m radius. Once you're sitting comfortably in a quiet spot,
 you can start by cloning the hackday-tetris repo. 
 
 After the repo is clones you'll need to run the following commands to 
 install and activate the environment:
  
`conda env create`

`conda activate tetris`

Then you can cd into app and run `python api.py` to start the server


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