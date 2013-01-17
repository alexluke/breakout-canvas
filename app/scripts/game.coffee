define [
    'requestAnimationFrame'
], (requestAnimationFrame) ->
    class Game
        @scaleCanvas: (ctx) ->
            canvas = ctx.canvas

            devicePixelRatio = window.devicePixelRatio or 1
            backingStoreRatio = ctx.webkitBackingStorePixelRatio or
                ctx.mozBackingStorePixelRatio or
                ctx.msBackingStorePixelRatio or
                ctx.oBackingStorePixelRatio or
                ctx.backingStorePixelRatio or
                1
            scaleRatio = devicePixelRatio / backingStoreRatio

            width = canvas.width
            height = canvas.height
            if scaleRatio != 1
                canvas.width = width * scaleRatio
                canvas.height = height * scaleRatio
                canvas.style.width = width + 'px'
                canvas.style.height = height + 'px'
                ctx.scale scaleRatio, scaleRatio

        constructor: (canvasEl) ->
            @canvas = document.getElementById(canvasEl)
            if not @canvas.getContext
                throw 'No canvas support'

            @ctx = @canvas.getContext '2d'

            @targetFrameRate = 60
            @mouse =
                x: 0
                y: 0
                leftButton: false
                rightbutton: false

            @width = @canvas.width
            @height = @canvas.height
            Game.scaleCanvas @ctx

            @init()

        start: ->
            document.addEventListener 'mousemove', (e) =>
                @mouse.x = e.pageX - @canvas.offsetLeft
                @mouse.y = e.pageY - @canvas.offsetTop

            document.addEventListener 'mousedown', (e) =>
                e.preventDefault()
                @mouse.leftButton = true

            document.addEventListener 'mouseup', (e) =>
                e.preventDefault()
                @mouse.leftButton = false

            requestAnimationFrame =>
                tick = =>
                    @draw()
                    requestAnimationFrame tick
                requestAnimationFrame tick

            @lastUpdate = (new Date).getTime()
            tick = =>
                now = (new Date).getTime()
                delta = (now - @lastUpdate) / (1000 / @targetFrameRate)
                @lastUpdate = now
                @update(delta)
            setInterval tick, 1000 / @targetFrameRate

        init: ->
        draw: ->
        update: ->
