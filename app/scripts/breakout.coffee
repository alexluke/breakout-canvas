define [
    'point'
    'sprites/paddle'
    'sprites/ball'
    'sprites/block'
], (Point, Paddle, Ball, Block) ->
    class Breakout
        constructor: (@width, @height) ->
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
            @paddle = new Paddle @width / 2, @height - 20
            ballX = @paddle.position.x + Paddle.texture.width / 2 - Ball.texture.width / 2
            ballY = @paddle.position.y - Ball.texture.height
            @ball = new Ball ballX, ballY
            @ballSpeed = 0
            @running = false

        draw: (ctx) ->
            ctx.fillStyle = 'rgb(100, 149, 237)'
            ctx.fillRect 0, 0, @width, @height

            block.draw(ctx) for block in @blocks
            @paddle.draw(ctx)
            @ball.draw(ctx)
