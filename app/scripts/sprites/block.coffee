define [
    'sprite'
], (Sprite) ->
    class Block extends Sprite
        @points = 10
        constructor: (@x, @y) ->
            @texture = Block.texture
            super()

            @points = Block.points

    Block.texture = Sprite.createTexture 50, 20, (ctx) ->
        ctx.clearRect 0, 0, 50, 20
        ctx.fillStyle = 'rgb(0, 0, 0)'
        ctx.fillRect 2, 2, 46, 16
        ctx.fillStyle = 'rgb(255, 255, 255)'
        ctx.fillRect 3, 3, 44, 14

    return Block
