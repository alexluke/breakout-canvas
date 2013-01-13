require [
    'breakout'
], (Breakout) ->
    canvas = document.getElementById('breakout')
    if not canvas.getContext
        alert 'No canvas support!'
        return

    ctx = canvas.getContext '2d'

    game = new Breakout(canvas.width, canvas.height)
    game.start(ctx)
