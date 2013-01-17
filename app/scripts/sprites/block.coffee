define [
    'sprite'
], (Sprite) ->
    class Block extends Sprite
        @points = 10
        constructor: (@x, @y) ->
            choice = Math.random()
            @texture =
                if choice < .33 then Block.blueTexture
                else if choice < .66 then Block.greenTexture
                else Block.redTexture
            super()

            @points = Block.points

    colorBlock = (color) ->
        Sprite.createTexture Block.texture.width, Block.texture.height, (ctx) ->
            ctx.drawImage Block.texture, 0, 0, Block.texture.width, Block.texture.height, 0, 0, Block.texture.naturalWidth, Block.texture.naturalHeight
            map = ctx.getImageData 0, 0, Block.texture.naturalWidth, Block.texture.naturalHeight, 0, 0, Block.texture.width, Block.texture.height
            data = map.data
            for p in [0...data.length] by 4
                if data[p] is 0 and data[p+1] is 0 and data[p+2] is 0
                    data[p] = color.r
                    data[p+1] = color.g
                    data[p+2] = color.b
            ctx.putImageData map, 0, 0

    Block.texture = document.getElementById 'block'
    Block.redTexture = colorBlock {r: 217, g: 80, b: 77}
    Block.greenTexture = colorBlock {r: 254, g: 255, b: 4}
    Block.blueTexture = colorBlock {r: 4, g: 102, b: 175}

    return Block
