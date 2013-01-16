define [
    'sprite'
], (Sprite) ->
    class Paddle extends Sprite
        constructor: (@x, @y) ->
            @texture = Paddle.texture
            super()

    Paddle.texture = Sprite.createTexture 54, 10, (ctx) ->
        ctx.fillStyle = 'rgb(217, 80, 77)'
        ctx.fillRect 2, 0, 50, 10

    return Paddle
