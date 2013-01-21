define [
    'game'
    'sound'
    'sprites/paddle'
    'sprites/ball'
    'sprites/block'
    'sprites/bonusblock'
], (Game, Sound, Paddle, Ball, Block, BonusBlock) ->
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
            @screen = 'title'

        resetLevel: ->
            @blocks = []
            for cols in [0...@blockCols]
                for rows in [0...@blockRows]
                    x = 20 + cols * Block.texture.width
                    y = 20 + rows * Block.texture.height
                    @blocks.push new Block x, y
            @lives = 4
            @resetPaddle()
            @score = 0

        resetPaddle: ->
            if not @paddle
                @paddle = new Paddle @width / 2, @height - 20
            ballX = @paddle.x + Paddle.texture.width / 2 - Ball.texture.width / 2
            ballY = @paddle.y - Ball.texture.height
            @ball = new Ball ballX, ballY
            @running = false
            if @lives > 0
                @lives -= 1
            else
                @screen = 'gameover'

        addBonusBlock: ->
            index = Math.floor(Math.random() * @blocks.length)
            return if not @blocks[index].alive
            bonus = BonusBlock.upgrade @blocks[index]
            @blocks[index] = bonus
            setTimeout =>
                index = @blocks.indexOf bonus
                if index > -1
                    @blocks[index] = @blocks[index].downgrade()
            , @pointBonusDuration * 1000
            return

        update: (delta) ->
            switch @screen
                when 'title'
                    if not @highScores?
                        if localStorage
                            builtinScores = [
                                {'name': 'Dollie', 'score': 50}
                                {'name': 'Erik', 'score': 40}
                                {'name': 'Neva', 'score': 30}
                                {'name': 'Tabatha', 'score': 20}
                                {'name': 'Lance', 'score': 10}
                            ]

                            localScores = JSON.parse localStorage.getItem 'highScores'
                            if not localScores?
                                localScores = []
                            @highScores = builtinScores.concat localScores
                            @highScores.sort (a,b) ->
                                0 if a.score == b.score
                                if a.score < b.score then 1 else -1
                            @highScores = @highScores.slice 0, 5
                        else
                            @highScores = []
                    if @mouse.leftButton
                        @screen = 'game'
                        # Prevent the ball from launching right away
                        @mouse.leftButton = false
                when 'gameover'
                    if @mouse.leftButton
                        if localStorage
                            name = prompt 'Enter your name'
                            if name
                                localScores = JSON.parse localStorage.getItem 'highScores'
                                if not localScores
                                    localScores = []
                                localScores.push
                                    name: name
                                    score: @score
                                localStorage.setItem 'highScores', JSON.stringify localScores
                                @highScores = null
                        @screen = 'title'
                        @resetLevel()
                        @mouse.leftButton = false
                else @gameUpdate delta

        gameUpdate: (delta) ->
            @paddle.x = @mouse.x - Paddle.texture.width / 2

            if @paddle.x < 0
                @paddle.x = 0
            if @paddle.x > @width - Paddle.texture.width
                @paddle.x = @width - Paddle.texture.width

            if Math.random() < @pointBonusChance
                @addBonusBlock()

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
                @ball.y = 0
                @ball.speed.y *= -1
                Sound.play 'ballHit'
            if @ball.x < 0 or @ball.x > @width - Ball.texture.width
                if @ball.x < 0
                    @ball.x = 0
                else
                    @ball.x = @width - Ball.texture.width
                @ball.speed.x *= -1
                Sound.play 'ballHit'
            if @ball.y > @height and not @resetting
                @ball.speed =
                    x: 0
                    y: 0
                @resetting = true
                setTimeout =>
                    @resetting = false
                    @resetPaddle()
                , 1000
                return

            if @ball.intersects @paddle
                @ball.speed.y *= -1
                @ball.speed.x = ((@ball.x + Ball.texture.width / 2) - (@paddle.x + Paddle.texture.width / 2)) / 3 * delta
                Sound.play 'ballHit'

            toRemove = []
            hitSomething = false
            for i in [0...@blocks.length]
                block = @blocks[i]
                if not block.update(delta)
                    toRemove.push i
                if not hitSomething and @ball.intersects block
                    @ball.speed.y *= -1
                    @score += block.points
                    block.alive = false
                    Sound.play 'blockBreak'
                    hitSomething = true

            toRemove.sort (a,b) ->
                0 if a == b
                if a < b then 1 else -1
            for i in toRemove
                @blocks.splice i, 1

            if @blocks.length == 0
                @screen = 'gameover'
                return

        draw: ->
            @ctx.drawImage @backgroundTexture, 0, 0, @width, @height

            block.draw(@ctx) for block in @blocks
            @paddle.draw(@ctx)
            @ball.draw(@ctx)

            @drawScorePanel()

            switch @screen
                when 'title' then @drawTitle()
                when 'gameover' then @drawGameOver()

        drawScorePanel: ->
            @ctx.save()
            @ctx.clearRect @canvas.width - @scorePanelWidth, 0, @scorePanelWidth, @canvas.height
            @ctx.strokeStyle = 'rgb(0, 0, 0)'
            @ctx.lineWidth = 4
            @ctx.strokeRect @canvas.width - @scorePanelWidth + 2, 2, @scorePanelWidth - 4, @canvas.height - 4

            @ctx.textAlign = 'center'
            @ctx.font = '24pt sans-serif'
            @ctx.fillText 'Score', @canvas.width - @scorePanelWidth / 2, 50
            @ctx.fillText 'Lives', @canvas.width - @scorePanelWidth / 2, 200

            @ctx.font = '32pt sans-serif'
            @ctx.fillStyle = 'rgb(4, 102, 175)'
            @ctx.fillText @score, @canvas.width - @scorePanelWidth / 2, 100
            @ctx.fillText @lives, @canvas.width - @scorePanelWidth / 2, 250
            @ctx.restore()

        drawFrame: (width, height) ->
            @ctx.save()
            @ctx.globalAlpha = .75
            @ctx.fillStyle = 'rgb(0, 0, 0)'
            @ctx.fillRect 0, 0, @canvas.width, @canvas.height
            @ctx.globalAlpha = 1
            @ctx.clearRect @canvas.width / 2 - width / 2, @canvas.height / 2 - height / 2, width, height
            @ctx.strokeStyle = 'rgb(0, 0, 0)'
            @ctx.lineWidth = 4
            @ctx.strokeRect @canvas.width / 2 - width / 2 + 2, @canvas.height / 2 - height / 2 + 2, width, height
            @ctx.restore()

        drawTitle: ->
            width = 300
            height = 400
            @drawFrame width, height
            @ctx.save()
            @ctx.textAlign = 'center'
            @ctx.font = '32pt sans-serif'
            @ctx.fillText 'Breakout!', @canvas.width / 2, @canvas.height / 2 - height / 2 + 50

            @ctx.fillStyle = 'rgb(4, 102, 175)'
            @ctx.fillRect @canvas.width / 2 - 80, @canvas.height / 2 - height / 2 + 70, 160, 40
            @ctx.font = '20pt sans-serif'
            @ctx.fillStyle = 'rgb(255, 255, 255)'
            @ctx.fillText 'New Game', @canvas.width / 2, @canvas.height / 2 - height / 2 + 100

            if @highScores?
                @ctx.font = '20pt sans-serif'
                @ctx.fillStyle = 'rgb(0, 0, 0)'
                @ctx.fillText 'High Scores:', @canvas.width / 2, @canvas.height / 2 - height / 2 + 175
                @ctx.font = '16pt sans-serif'
                x = @canvas.width / 2 - 110
                y = @canvas.height / 2 - height / 2 + 220
                for hs in @highScores
                    @ctx.textAlign = 'left'
                    @ctx.fillText hs.name, x, y
                    @ctx.textAlign = 'right'
                    @ctx.fillText hs.score, x + 220, y
                    y += 35

            @ctx.restore()

        drawGameOver: ->
            width = 300
            height = 150
            @drawFrame width, height
            @ctx.save()
            @ctx.textAlign = 'center'
            @ctx.font = '32pt sans-serif'
            @ctx.fillText 'Game Over', @canvas.width / 2, @canvas.height / 2 - height / 2 + 50
            @ctx.font = '20pt sans-serif'
            @ctx.textAlign = 'left'
            scoreSize = @ctx.measureText "Your score: #{ @score }"
            @ctx.fillText "Your score: ", @canvas.width / 2 - scoreSize.width / 2, @canvas.height / 2 - height / 2 + 100
            @ctx.textAlign = 'right'
            @ctx.fillStyle = 'rgb(4, 102, 175)'
            @ctx.fillText @score, @canvas.width / 2 + scoreSize.width / 2, @canvas.height / 2 - height / 2 + 100
            @ctx.restore()
