define [
    'sprite'
], (Sprite) ->
    class Ball extends Sprite
        constructor: (@x, @y) ->
            @texture = Ball.texture
            super()

            @speed =
                x: 0
                y: 0

        launch: ->
            @speed.y = -5

    Ball.texture = Sprite.createTexture 10, 10, (ctx) ->
        ctx.fillStyle = 'rgb(255, 255, 255)'
        ctx.beginPath()
        ctx.arc 5, 5, 5, 0, Math.PI*2, false
        ctx.fill()

    return Ball
