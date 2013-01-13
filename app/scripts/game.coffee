# Adapted from http://nokarma.org/2011/02/02/javascript-game-development-the-game-loop/index.html
define [
    'requestAnimationFrame'
], (requestAnimationFrame) ->
    class Game
        constructor: (canvasEl) ->
            @canvas = document.getElementById(canvasEl)
            if not @canvas.getContext
                throw 'No canvas support'

            @ctx = @canvas.getContext '2d'
            @loops = 0
            @fps = 60
            @skipTicks = 1000 / @fps
            @maxFrameSkip = 10
            @nextGameTick = (new Date).getTime()

            @init()

        run: ->
            @loops = 0

            while (new Date).getTime() > @nextGameTick and @loops < @maxFrameSkip
                @update()
                @nextGameTick += @skipTicks
                @loops++

            @draw(@ctx)

        start: ->
            requestAnimationFrame =>
                @run()

        init: ->
        draw: ->
        update: ->
