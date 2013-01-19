define ->
    class Sprite
        @createTexture: (width, height, create) ->
            texture = document.createElement('canvas')
            texture.width = width
            texture.height = height

            if not texture.getContext
                throw 'No canvas support'
            ctx = texture.getContext '2d'

            create(ctx)

            texture.style.display = 'none'
            document.body.appendChild(texture)

        constructor: ->
            if not @texture
                throw 'Sprite must set texture'

            @alive = true

        draw: (ctx) ->
            ctx.drawImage @texture, @x, @y, @texture.width, @texture.height

        intersects: (otherSprite) ->
            withinX = @x + @texture.width > otherSprite.x and @x < otherSprite.x + otherSprite.texture.width
            withinY = @y + @texture.height > otherSprite.y and @y < otherSprite.y + otherSprite.texture.height
            return withinX and withinY and otherSprite.alive
