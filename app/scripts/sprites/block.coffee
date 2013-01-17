define [
    'sprite'
], (Sprite) ->
    class Block extends Sprite
        @points = 10
        constructor: (@x, @y, @color) ->
            if not @color?
                choice = Math.random()
                @color =
                    if choice < .33 then 'blue'
                    else if choice < .66 then 'green'
                    else 'red'
            @texture = switch @color
                when 'blue' then Block.blueTexture
                when 'green' then Block.greenTexture
                when 'red' then Block.redTexture
                else throw 'Invalid block color'
            super()

            @points = Block.points

    Block.colorBlock = (color, texture) ->
        Sprite.createTexture texture.width, texture.height, (ctx) ->
            ctx.drawImage texture, 0, 0, texture.width, texture.height
            map = ctx.getImageData 0, 0, texture.width, texture.height
            data = map.data
            for p in [0...data.length] by 4
                if not (data[p] is 255 and data[p+1] is 255 and data[p+2] is 255)
                    data[p] = color.r
                    data[p+1] = color.g
                    data[p+2] = color.b
            ctx.putImageData map, 0, 0

    Block.texture = document.getElementById 'block'
    Block.colors =
        red: {r: 217, g: 80, b: 77}
        green: {r: 254, g: 255, b: 4}
        blue: {r: 4, g: 102, b: 175}
    Block.redTexture = Block.colorBlock Block.colors.red, Block.texture
    Block.greenTexture = Block.colorBlock Block.colors.green, Block.texture
    Block.blueTexture = Block.colorBlock Block.colors.blue, Block.texture

    return Block
