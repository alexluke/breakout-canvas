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
            @breakingFrameTime = 2
            @timeSinceBreak = 0

        update: (delta) ->
            if not @alive
                @timeSinceBreak += delta
                @currentBreakFrame = Math.floor @timeSinceBreak / @breakingFrameTime
                return false if @currentBreakFrame > 3
            return true
            
        draw: (ctx) ->
            if not @alive and @currentBreakFrame?
                brokenTexture = switch @currentBreakFrame
                    when 0 then Block.breakTexture1Colored[@color]
                    when 1 then Block.breakTexture2Colored[@color]
                    when 2 then Block.breakTexture3Colored[@color]
                    when 3 then Block.breakTexture4Colored[@color]
                scale =
                    x: brokenTexture.width / @texture.width * 2
                    y: brokenTexture.height / @texture.height * 2
                ctx.save()
                ctx.globalAlpha = 1.0 / (@currentBreakFrame + 1)
                ctx.drawImage brokenTexture, @x - brokenTexture.width / scale.x, @y - brokenTexture.height / scale.y, brokenTexture.width, brokenTexture.height
                ctx.restore()
            else
                super ctx

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

    Block.breakTexture1 = document.getElementById 'blockBreak1'
    Block.breakTexture1Colored =
        red: Block.colorBlock Block.colors.red, Block.breakTexture1
        green: Block.colorBlock Block.colors.green, Block.breakTexture1
        blue: Block.colorBlock Block.colors.blue, Block.breakTexture1
    Block.breakTexture2 = document.getElementById 'blockBreak2'
    Block.breakTexture2Colored =
        red: Block.colorBlock Block.colors.red, Block.breakTexture2
        green: Block.colorBlock Block.colors.green, Block.breakTexture2
        blue: Block.colorBlock Block.colors.blue, Block.breakTexture2
    Block.breakTexture3 = document.getElementById 'blockBreak3'
    Block.breakTexture3Colored =
        red: Block.colorBlock Block.colors.red, Block.breakTexture3
        green: Block.colorBlock Block.colors.green, Block.breakTexture3
        blue: Block.colorBlock Block.colors.blue, Block.breakTexture3
    Block.breakTexture4 = document.getElementById 'blockBreak4'
    Block.breakTexture4Colored =
        red: Block.colorBlock Block.colors.red, Block.breakTexture4
        green: Block.colorBlock Block.colors.green, Block.breakTexture4
        blue: Block.colorBlock Block.colors.blue, Block.breakTexture4

    return Block
