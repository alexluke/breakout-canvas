define [
    'sprite'
], (Sprite) ->
    class Paddle extends Sprite
        constructor: (@x, @y) ->
            @texture = Paddle.texture
            super()

    Paddle.texture = Sprite.createTexture 50, 10, (ctx) ->
        ctx.fillStyle = 'rgb(255, 255, 255)'
        ctx.fillRect 0, 0, 50, 10

    return Paddle
