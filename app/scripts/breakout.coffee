define [
    'game'
    'point'
    'sprites/paddle'
    'sprites/ball'
    'sprites/block'
], (Game, Point, Paddle, Ball, Block) ->
    class Breakout extends Game
        init: ->
            @blockRows = 5
            @blockCols = 15
            @blocks = []
            @resetLevel()

        resetLevel: ->
            for cols in [0...@blockCols]
                for rows in [0...@blockRows]
                    x = 20 + cols * Block.texture.width
                    y = 20 + rows * Block.texture.height
                    @blocks.push new Block x, y
            @resetPaddle()

        resetPaddle: ->
            @paddle = new Paddle @canvas.width / 2, @canvas.height - 20
            ballX = @paddle.x + Paddle.texture.width / 2 - Ball.texture.width / 2
            ballY = @paddle.y - Ball.texture.height
            @ball = new Ball ballX, ballY
            @ballSpeed = 0
            @running = false

        draw: ->
            @ctx.fillStyle = 'rgb(100, 149, 237)'
            @ctx.fillRect 0, 0, @canvas.width, @canvas.height

            block.draw(@ctx) for block in @blocks
            @paddle.draw(@ctx)
            @ball.draw(@ctx)
