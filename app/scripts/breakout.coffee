define [
    'game'
    'sprites/paddle'
    'sprites/ball'
    'sprites/block'
    'sprites/bonusblock'
], (Game, Paddle, Ball, Block, BonusBlock) ->
    class Breakout extends Game
        init: ->
            @blockRows = 5
            @blockCols = 15
            @blocks = []
            @pointBonusChance = .001
            @pointBonusDuration = 10
            @resetLevel()

        resetLevel: ->
            for cols in [0...@blockCols]
                for rows in [0...@blockRows]
                    x = 20 + cols * Block.texture.width
                    y = 20 + rows * Block.texture.height
                    @blocks.push new Block x, y
            @score = 0
            @resetPaddle()

        resetPaddle: ->
            if not @paddle
                @paddle = new Paddle @canvas.width / 2, @canvas.height - 20
            ballX = @paddle.x + Paddle.texture.width / 2 - Ball.texture.width / 2
            ballY = @paddle.y - Ball.texture.height
            @ball = new Ball ballX, ballY
            @running = false

        addBonusBlock: ->
            index = Math.floor(Math.random() * @blocks.length)
            bonus = BonusBlock.upgrade @blocks[index]
            @blocks[index] = bonus
            setTimeout =>
                index = @blocks.indexOf bonus
                if index > -1
                    @blocks[index] = @blocks[index].downgrade()
            , @pointBonusDuration * 1000
            return

        update: ->
            @paddle.x = @mouse.x - Paddle.texture.width / 2

            if @paddle.x < 0
                @paddle.x = 0
            if @paddle.x > @canvas.width - Paddle.texture.width
                @paddle.x = @canvas.width - Paddle.texture.width

            if not @running
                @ball.x = @paddle.x + Paddle.texture.width / 2 - Ball.texture.width / 2
                if @mouse.leftButton
                    @running = true
                    @ball.launch()
                else
                    return

            @ball.x += @ball.speed.x
            @ball.y += @ball.speed.y

            if @ball.y < 0
                @ball.speed.y *= -1
            if @ball.x < 0 or @ball.x > @canvas.width - Ball.texture.width
                @ball.speed.x *= -1
            if @ball.y > @canvas.height
                @resetPaddle()
                return

            if @ball.intersects @paddle
                @ball.speed.y *= -1
                @ball.speed.x = ((@ball.x + Ball.texture.width / 2) - (@paddle.x + Paddle.texture.width / 2)) / 3

            for block in @blocks
                if @ball.intersects block
                    @blocks[t..t] = [] if (t = @blocks.indexOf(block)) > -1
                    @ball.speed.y *= -1
                    @score += block.points
                    console.log "Current points: #{ @score }"
                    break

            if @blocks.length == 0
                @resetLevel()
                return

            if Math.random() < @pointBonusChance
                @addBonusBlock()

        draw: ->
            @ctx.fillStyle = 'rgb(100, 149, 237)'
            @ctx.fillRect 0, 0, @canvas.width, @canvas.height

            block.draw(@ctx) for block in @blocks
            @paddle.draw(@ctx)
            @ball.draw(@ctx)
