define [
    'requestAnimationFrame'
], (requestAnimationFrame) ->
    class Game
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
