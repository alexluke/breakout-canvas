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
            @blockCols = 12
            @blocks = []
            @pointBonusChance = .001
            @pointBonusDuration = 10
            @scorePanelWidth = 160
            @backgroundTexture = document.getElementById 'background'
            @width = @canvas.width - @scorePanelWidth
            @height = @canvas.height
            @resetLevel()

        resetLevel: ->
            for cols in [0...@blockCols]
                for rows in [0...@blockRows]
                    x = 20 + cols * Block.texture.width
                    y = 20 + rows * Block.texture.height
                    @blocks.push new Block x, y
            @resetPaddle()

        resetPaddle: ->
            if not @paddle
                @paddle = new Paddle @width / 2, @height - 20
            ballX = @paddle.x + Paddle.texture.width / 2 - Ball.texture.width / 2
            ballY = @paddle.y - Ball.texture.height
            @ball = new Ball ballX, ballY
            @running = false
            @score = 0

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

        update: (delta) ->
            @paddle.x = @mouse.x - Paddle.texture.width / 2

            if @paddle.x < 0
                @paddle.x = 0
            if @paddle.x > @width - Paddle.texture.width
                @paddle.x = @width - Paddle.texture.width

            if not @running
                @ball.x = @paddle.x + Paddle.texture.width / 2 - Ball.texture.width / 2
                if @mouse.leftButton
                    @running = true
                    @ball.launch()
                else
                    return

            @ball.x += @ball.speed.x * delta
            @ball.y += @ball.speed.y * delta

            if @ball.y < 0
                @ball.speed.y *= -1
            if @ball.x < 0 or @ball.x > @width - Ball.texture.width
                @ball.speed.x *= -1
            if @ball.y > @height
                @resetPaddle()
                return

            if @ball.intersects @paddle
                @ball.speed.y *= -1
                @ball.speed.x = ((@ball.x + Ball.texture.width / 2) - (@paddle.x + Paddle.texture.width / 2)) / 3 * delta

            for block in @blocks
                if @ball.intersects block
                    @blocks[t..t] = [] if (t = @blocks.indexOf(block)) > -1
                    @ball.speed.y *= -1
                    @score += block.points
                    break

            if @blocks.length == 0
                @resetLevel()
                return

            if Math.random() < @pointBonusChance
                @addBonusBlock()

        draw: ->
            @ctx.drawImage @backgroundTexture, 0, 0, @width, @height

            block.draw(@ctx) for block in @blocks
            @paddle.draw(@ctx)
            @ball.draw(@ctx)

            @drawScorePanel()

        drawScorePanel: ->
            @ctx.save()
            @ctx.clearRect @canvas.width - @scorePanelWidth, 0, @scorePanelWidth, @canvas.height
            @ctx.strokeStyle = 'rgb(0, 0, 0)'
            @ctx.lineWidth = 4
            @ctx.strokeRect @canvas.width - @scorePanelWidth + 2, 2, @scorePanelWidth - 4, @canvas.height - 4

            @ctx.textAlign = 'center'
            @ctx.font = '24pt sans-serif'
            @ctx.fillText 'Score', @canvas.width - @scorePanelWidth / 2, 50

            @ctx.font = '32pt sans-serif'
            @ctx.fillStyle = 'rgb(4, 102, 175)'
            @ctx.fillText @score, @canvas.width - @scorePanelWidth / 2, 100

            @ctx.restore()
