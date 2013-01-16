define [
    'sprite'
], (Sprite) ->
    class Block extends Sprite
        @points = 10
        constructor: (@x, @y) ->
            choice = Math.random()
            @texture =
                if choice < .33 then Block.greenTexture
                else if choice < .66 then Block.yellowTexture
                else Block.redTexture
            super()

            @points = Block.points

    colorBlock = (color) ->
        Sprite.createTexture Block.texture.width, Block.texture.height, (ctx) ->
            ctx.drawImage Block.texture, 0, 0, Block.texture.width, Block.texture.height
            map = ctx.getImageData 0, 0, Block.texture.width, Block.texture.height
            data = map.data
            for p in [0...data.length] by 4
                if data[p] is 0 and data[p+1] is 0 and data[p+2] is 0
                    data[p] = color.r
                    data[p+1] = color.g
                    data[p+2] = color.b
            ctx.putImageData map, 0, 0

    Block.texture = document.getElementById 'block'
    Block.greenTexture = colorBlock {r: 51, g: 109, b: 43}
    Block.yellowTexture = colorBlock {r: 220, g: 181, b: 73}
    Block.redTexture = colorBlock {r: 207, g: 66, b: 34}

    return Block
