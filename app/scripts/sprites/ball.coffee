define [
    'sprite'
    'point'
], (Sprite, Point) ->
    class Ball extends Sprite
        constructor: (x, y) ->
            @texture = Ball.texture
            @position = new Point x, y
            super()

    Ball.texture = Sprite.createTexture 10, 10, (ctx) ->
        ctx.fillStyle = 'rgb(255, 255, 255)'
        ctx.beginPath()
        ctx.arc 5, 5, 5, 0, Math.PI*2, false
        ctx.fill()

    return Ball
