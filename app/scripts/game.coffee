# Adapted from http://nokarma.org/2011/02/02/javascript-game-development-the-game-loop/index.html
define [
    'requestAnimationFrame'
], (requestAnimationFrame) ->
    class Game
        constructor: ->
            @loops = 0
            @fps = 60
            @skipTicks = 1000 / @fps
            @maxFrameSkip = 10
            @nextGameTick = (new Date).getTime()

        run: ->
            @loops = 0

            while (new Date).getTime() > @nextGameTick and @loops < @maxFrameSkip
                @update()
                @nextGameTick += @skipTicks
                @loops++

            @draw(@ctx)

        start: (ctx) ->
            @ctx = ctx
            requestAnimationFrame =>
                @run()

        draw: ->
        update: ->
