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
            @backgroundTexture = document.getElementById 'background'
            @resetLevel()

        resetLevel: ->
            # This block instance is used to get the proper width
            # and height of the block sprite. It differs depending
            # on devicePixelRatio, but instanciating a sprite
            # calculates the correct value
            dummyBlock = new Block 0, 0
            for cols in [0...@blockCols]
                for rows in [0...@blockRows]
                    x = 20 + cols * dummyBlock.width
                    y = 20 + rows * dummyBlock.height
                    @blocks.push new Block x, y
            @resetPaddle()

        resetPaddle: ->
            if not @paddle
                @paddle = new Paddle @width / 2, @height - 20
            @ball = new Ball()
            @ball.x = @paddle.x + @paddle.width / 2 - @ball.width / 2
            @ball.y = @paddle.y - @ball.height
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
            @paddle.x = @mouse.x - @paddle.width / 2

            if @paddle.x < 0
                @paddle.x = 0
            if @paddle.x > @width - @paddle.width
                @paddle.x = @width - @paddle.width

            if not @running
                @ball.x = @paddle.x + @paddle.width / 2 - @ball.width / 2
                if @mouse.leftButton
                    @running = true
                    @ball.launch()
                else
                    return

            @ball.x += @ball.speed.x * delta
            @ball.y += @ball.speed.y * delta

            if @ball.y < 0
                @ball.speed.y *= -1
            if @ball.x < 0 or @ball.x > @width - @ball.width
                @ball.speed.x *= -1
            if @ball.y > @height
                @resetPaddle()
                return

            if @ball.intersects @paddle
                @ball.speed.y *= -1
                @ball.speed.x = ((@ball.x + @ball.width / 2) - (@paddle.x + @paddle.width / 2)) / 3 * delta

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
            @ctx.drawImage @backgroundTexture, 0, 0, @backgroundTexture.width, @backgroundTexture.height

            block.draw(@ctx) for block in @blocks
            @paddle.draw(@ctx)
            @ball.draw(@ctx)
