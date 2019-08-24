
// Use a "/test" namespace.
// An application can open a connection on multiple namespaces, and
// Socket.IO will multiplex all those connections on a single
// physical channel. If you don't care about multiple channels, you
// can set the namespace to an empty string.
namespace = '/test';

// Connect to the Socket.IO server.
// The connection URL has the following format, relative to the current page:
//     http[s]://<domain>:<port>[/<namespace>]
const socket = io(namespace);

socket.on('connect', function () {
    console.log('Connected to websocket');
});

const LEVELS = {
    1: {
        speed: 800,
        lines: 6
    },
    2: {
        speed: 720,
        lines: 6
    },
    3: {
        speed: 630,
        lines: 6
    },
    4: {
        speed: 550,
        lines: 6
    },
    5: {
        speed: 470,
        lines: 8
    },
    6: {
        speed: 380,
        lines: 8
    },
    7: {
        speed: 300,
        lines: 8
    },
    8: {
        speed: 220,
        lines: 8
    },
    9: {
        speed: 200,
        lines: 10
    },
    10: {
        speed: 150,
        lines: 10
    },
    11: {
        speed: 100,
        lines: 10
    },
    12: {
        speed: 80,
        lines: 10
    },
    13: {
        speed: 70,
        lines: 12
    },
    14: {
        speed: 60,
        lines: 12
    },
    15: {
        speed: 50,
        lines: 12
    },
    16: {
        speed: 30,
        lines: 12
    },
    17: {
        speed: 20,
        lines: 12
    },
    18: {
        speed: 10,
        lines: 12
    }
};

MAX_LEVEL = 18;


const SHAPES = {
    1: {
        pattern: [
            [1, 1],
            [1, 1]
        ],
        fill: '#3f3dff',
        id: 1
    },
    2: {
        pattern: [
            [1, 1, 1, 1]
        ],
        fill: '#ff4846',
        id: 2
    },
    3: {
        pattern: [
        [1, 1],
        [1, 0],
        [1, 0]
    ],
        fill: '#fffd3b',
        id: 3
    },
    4: {
        pattern: [
        [1, 1],
        [0, 1],
        [0, 1]
    ],
        fill: '#4aff49',
        id: 4
    },
    5: {
        pattern: [
            [1, 0],
            [1, 1],
            [0, 1]
        ],
        fill: '#4afffa',
        id: 5
    },
    6: {
        pattern: [
            [0, 1],
            [1, 1],
            [1, 0]
        ],
        fill: '#ff3cfe',
        id:6
    },
    7: {
        pattern: [
            [1, 0],
            [1, 1],
            [1, 0]
        ],
        fill: '#ff3895',
        id:7
    }
};

class UserBlock {
    constructor(shape) {
        this.shape = shape;
        this.x = 3;
        this.y = 0;
    }

    rotate() {
        let grid = this.shape.pattern;
        const numberOfOriginalColumns = grid[0].length;
        const numberOfOriginalRows = grid.length;

        const newGrid = [];

        for(let x=0; x<numberOfOriginalColumns;x++){
          const newRows = [];

          for(let y=numberOfOriginalRows-1; y>=0;y--){
            const gridValue = grid[y][x];
            newRows.push(gridValue);
          }

          newGrid.push(newRows)
        }

        this.shape.pattern = newGrid;
    }

}

class Renderer {

    constructor() {
        this.background = document.getElementById('game-background');
        const background_index = Math.floor(Math.random() * 6);
        this.background.style.backgroundImage = `url(static/img/background_${background_index}.gif)`;
        this.canvas = document.getElementById('game-grid');
        this.context = this.canvas.getContext('2d');
        this.scoreElement = document.getElementById('score');
        this.linesElement = document.getElementById('lines');
        this.nextCanvas = document.getElementById('next');
        this.nextElementContext = this.nextCanvas.getContext('2d');
        this.step = 16;
    }

    _refreshGrid() {
        this.context.fillStyle = 'black';
        this.context.fillRect(0, 0, 160, 320);
    }

    _drawBlock(x, y, fill) {
        this.context.fillStyle = fill;
        this.context.strokeStyle = 'black';
        this.context.fillRect(x * this.step, y * this.step, this.step, this.step);
        this.context.strokeRect(x * this.step, y * this.step, this.step, this.step);

    }

    drawShape(x, y, shape) {
        const pattern = shape.pattern;
        const fill = shape.fill;
        for (let i = 0; i < pattern.length; i++) {
            for (let j = 0; j < pattern[i].length; j++) {
                if (pattern[i][j]) {
                    this._drawBlock(j + x, i + y, fill);
                }
            }
        }
    }


    renderGrid(grid, text, level) {
        this._refreshGrid();
        for (let i = 0; i < 20; i++) {
            for (let j = 0; j < 10; j++) {
                if (grid[i][j]) {
                    this._drawBlock(j, i, SHAPES[grid[i][j]].fill);
                }
            }
        }
        if (text) {
            const fontSize = 20;
            this.context.font = `${fontSize}px monospace`;
            this.context.fillStyle = 'white';
            this.context.textAlign = 'center';
            if (text === 'READY') {
                this.context.fillText(`LEVEL ${level}`, (5 * this.step), 100);
            }
            this.context.fillText(text, (5 * this.step), 130);
        }
    }

    renderNextInScoreBoard(next){
      this.nextElementContext.clearRect(0, 0, this.nextCanvas.width, this.nextCanvas.height);
      const pattern = next.pattern;
        const fill = next.fill;
        for (let i = 0; i < pattern.length; i++) {
            for (let j = 0; j < pattern[i].length; j++) {
                if (pattern[i][j]) {
                    this._drawNext(j, i, fill);
                }
            }
        }
    }

    _drawNext(x, y, fill) {
      this.nextElementContext.fillStyle = fill;
      this.nextElementContext.strokeStyle = 'black';
      this.nextElementContext.fillRect(x * this.step, y * this.step, this.step, this.step);
      this.nextElementContext.strokeRect(x * this.step, y * this.step, this.step, this.step);
  }

    renderScore(score, lines) {
      this.scoreElement.innerHTML = score;
      this.linesElement.innerHTML = lines;
    }

}


class Game {
    constructor(level) {
        this.interval = null;
        this.renderer = new Renderer();
        this.grid = [];
        for(let i = 0; i < 20; i++){
            this.grid.push(new Array(10).fill(0));
        }
        this.current = new UserBlock(this._generate_shape());
        this.next = this._generate_shape();
        this.renderer.renderNextInScoreBoard(this.next);
        this.lines = 0;
        this.score = 0;
        this.commands = [
          'LEFT',
          'RIGHT',
          'DOWN',
          'ROTATE'
        ];
        this.lines = 0;
        this.total_lines = 0;
        this.level = level;
        this.states = {
            READY: 'READY',
            IN_PLAY: '',
            GAME_OVER: 'GAME OVER',
            COMPLETE: 'COMPLETE!!!'
        };
        this.state = this.states.READY;
        this.gameLoop = (() => {
            socket.emit("updated_state", {
              grid: this.grid,
              next: this.next.id,
              current: {
                pattern: this.current.shape.pattern,
                x: this.current.x,
                y: this.current.y
              }
            });
            game.update();
        });
    }

    resetGrid() {
        this.grid = [];
        for(let i = 0; i < 20; i++){
            this.grid.push(new Array(10).fill(0));
        }
    }


    calculateScore(numberOfLinesCompleted){
      if(!numberOfLinesCompleted){
        return false;
      }
      const lineScores = {
        1: 40,
        2: 100,
        3: 300,
        4: 1200
      };
      const lineScore = numberOfLinesCompleted > 4 ? 4 : lineScores[numberOfLinesCompleted];
      const score = lineScore * this.level;
      this.score += score;
      this.renderer.renderScore(this.score, this.total_lines);
    }

    action(command_number) {
        let blockedRight = false;
        let blockedLeft = false;
        let y = this.current.y;
        let height = this.current.shape.pattern.length;
        let x = this.current.x;
        let width = this.current.shape.pattern[0].length;
        for(let i = y, i1 = 0; i < y + height; i++, i1++) {
            for(let j = x, j1 = 0; j < x + width; j++, j1++) {
                if (this.current.shape.pattern[i1][j1]) {
                    if (this.grid[i][j + 1] || j + 1 > 9) {
                        blockedRight = true;
                    }
                    if (this.grid[i][j - 1] || j - 1 < 0) {
                        blockedLeft = true;
                    }
                }
            }
        }

        if (command_number === 1) {
            if (!blockedLeft) {
                this.current.x -= 1;
            }
            return this.redraw();
        }
        if (command_number === 2) {
            if (!blockedRight) {
                this.current.x += 1;
            }
            return this.redraw();

        }
        if (command_number === 3) {
           this.update();
        }
        if (command_number === 4) {
            let lastPattern = [...this.current.shape.pattern];
            this.current.rotate();
            this.current.x = Math.max(this.current.x, 0);
            this.current.x = Math.min(this.current.x, 10 - this.current.shape.pattern[0].length);
            this.current.y = Math.min(this.current.y, 20 - this.current.shape.pattern.length);
            height = this.current.shape.pattern.length;
            width = this.current.shape.pattern[0].length;
            for(let i = y, i1 = 0; i < y + height; i++, i1++) {
                for(let j = x, j1 = 0; j < x + width; j++, j1++) {
                    if (this.current.shape.pattern[i1][j1]) {
                        if (i < 20 && this.grid[i][j]) {
                            this.current.shape.pattern = lastPattern;
                            return;
                        }
                    }
                }
            }
            return this.redraw();
        }
    }

    _generate_shape() {
        return SHAPES[Math.floor(Math.random() * 7) + 1]
    }

    _addUserBlockToGrid() {

        let y = this.current.y;
        let height = this.current.shape.pattern.length;
        let x = this.current.x;
        let width = this.current.shape.pattern[0].length;

        for(let i = y, i1 = 0; i < y + height; i++, i1++) {
            for(let j = x, j1 = 0; j < x + width; j++, j1++) {
                if (this.current.shape.pattern[i1][j1]) {
                    if (this.grid[i][j]) {
                        return this.gameOver();
                    }
                    this.grid[i][j] = this.current.shape.id;
                }
            }
        }

        for(let i = this.current.shape.pattern.x; i < this.current.shape.pattern[0].length; i++) {
            for(let j = this.current.shape.pattern.y; j < this.current.shape.pattern[i].length; j++) {
                this.grid[i][j] = this.current.shape.id;
            }
        }

        let numberOfLinesCompleted = 0;

        for (let i = 0; i < this.grid.length; i++) {
            let complete = true;

            this.grid[i].forEach(element => {
                if (element === 0) {
                    complete = false;
                }
            });

            if (complete) {
                numberOfLinesCompleted += 1;
                this.grid.splice(i, 1);
                this.grid.unshift(new Array(10).fill(0));
                this.lines += 1;
                this.total_lines += 1;

            }
        }
        this.calculateScore(numberOfLinesCompleted);

        if (this.lines >= LEVELS[this.level].lines) {
            if (this.level === MAX_LEVEL) {
                this.state = this.states.COMPLETE;
                clearInterval(this.interval);
                this.redraw()
            } else {
                this.nextLevel();
            }
        }

        this.current = new UserBlock(this.next);
        this.next = this._generate_shape();
        this.renderer.renderNextInScoreBoard(this.next);

    }

    update() {
        if (this.state === this.states.IN_PLAY) {
            let y = this.current.y;
            let height = this.current.shape.pattern.length;
            let x = this.current.x;
            let width = this.current.shape.pattern[0].length;
            if (this.current.y + this.current.shape.pattern.length === 20) {
                this._addUserBlockToGrid();
                return this.redraw();
            }

            for (let i = y, i1 = 0; i < Math.min(y + height); i++, i1++) {
                for (let j = x, j1 = 0; j < x + width; j++, j1++) {
                    if ((this.current.shape.pattern[i1][j1] && this.grid[i + 1][j]) || i === 19) {
                        this._addUserBlockToGrid();
                        return this.redraw();
                    }
                }
            }
            this.current.y += 1;
        }
        if (this.state === this.states.GAME_OVER) {
            this.resetGrid();
        }
        this.redraw();
    }

    redraw() {
        this.renderer.renderGrid(this.grid, this.state, this.level);
        if (this.state === this.states.IN_PLAY) {
            this.renderer.drawShape(this.current.x, this.current.y, this.current.shape);
        }
    }

    start() {
        this.state = this.states.IN_PLAY;
        clearInterval(this.interval);
        this.interval = setInterval(this.gameLoop, LEVELS[this.level].speed);
    }

    gameOver() {
        this.state = this.states.GAME_OVER;
        clearInterval(this.interval);
        this.redraw();
    }

    nextLevel() {
        this.state = this.states.READY;
        this.lines = 0;
        this.level += 1;
        clearInterval(this.interval);
        this.redraw();
    }

}

const game = new Game(1);
game.redraw();

socket.on('my_response', function (msg, cb) {
    if (msg.action) {
        game.action(msg.action || msg);
    }
});

document.addEventListener('keydown', event => {
    if (event.keyCode === 37) {
        game.action(1);
    }
    if (event.keyCode === 39) {
        game.action(2);
    }
    if (event.keyCode === 40) {
        game.action(3);
    }
    if (event.keyCode === 38) {
        game.action(4);
    }
    if (game.state === game.states.READY) {
        game.start();t
    }
});