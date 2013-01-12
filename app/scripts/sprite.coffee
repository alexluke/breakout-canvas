define [
    'point'
], (Point) ->
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
            if not @position
                @position = new Point 0, 0


        draw: (ctx) ->
            ctx.drawImage @texture, @position.x, @position.y
