define [
    'sprite'
], (Sprite) ->
    texture = Sprite.createTexture 50, 10, (ctx) ->
        ctx.fillStyle = 'rgb(255, 255, 255)'
        ctx.fillRect 0, 0, 50, 10

    class Paddle extends Sprite
        constructor: ->
            @texture = texture
            super()

