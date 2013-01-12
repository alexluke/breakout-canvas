require [
    'sprites/paddle'
], (Paddle) ->
    canvas = document.getElementById('breakout')
    if not canvas.getContext
        alert 'No canvas support!'
        return

    ctx = canvas.getContext '2d'
    width = canvas.width
    height = canvas.height

    ctx.fillRect 0, 0, width, height

    paddle = new Paddle
    paddle.draw ctx
