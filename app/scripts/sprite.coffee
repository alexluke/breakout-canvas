define [
    'game'
], (Game) ->
    class Sprite
        @createTexture: (width, height, create) ->
            texture = document.createElement('canvas')
            texture.width = width
            texture.height = height

            if not texture.getContext
                throw 'No canvas support'
            ctx = texture.getContext '2d'

            Game.scaleCanvas ctx

            create(ctx)

            #texture.style.display = 'none'
            document.body.appendChild(texture)

        constructor: ->
            if not @texture
                throw 'Sprite must set texture'

            @width = @texture.width
            @height = @texture.height
            if @texture.tagName == 'CANVAS'
                @width /= 2
                @height /= 2

        draw: (ctx) ->
            if @texture.naturalWidth and @texture.naturalHeight
                ctx.drawImage @texture, 0, 0, @texture.naturalWidth, @texture.naturalHeight, @x, @y, @width, @height
            else
                ctx.drawImage @texture, 0, 0, @texture.width, @texture.height, @x, @y, @width, @height

        intersects: (otherSprite) ->
            withinX = @x + @width > otherSprite.x and @x < otherSprite.x + otherSprite.width
            withinY = @y + @height > otherSprite.y and @y < otherSprite.y + otherSprite.height
            return withinX and withinY
