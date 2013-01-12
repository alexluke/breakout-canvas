define [
    'sprite'
    'point'
], (Sprite, Point) ->
    texture = Sprite.createTexture 50, 20, (ctx) ->
        ctx.clearRect 0, 0, 50, 20
        ctx.fillStyle = 'rgb(255, 255, 255)'
        ctx.fillRect 2, 2, 46, 16
        ctx.fillStyle = 'rgb(0, 0, 0)'
        ctx.strokeRect 2, 2, 46, 16

    class Block extends Sprite
        constructor: (x, y) ->
            @texture = texture
            @position = new Point x, y
            super()
