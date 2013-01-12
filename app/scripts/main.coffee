require [
    'sprites/paddle'
    'sprites/ball'
    'sprites/block'
], (Paddle, Ball, Block) ->
    canvas = document.getElementById('breakout')
    if not canvas.getContext
        alert 'No canvas support!'
        return

    ctx = canvas.getContext '2d'
    width = canvas.width
    height = canvas.height

    ctx.fillRect 0, 0, width, height

    paddle = new Paddle 0, 0
    paddle.draw ctx

    ball = new Ball 50, 50
    ball.draw ctx

    block = new Block 100, 100
    block.draw ctx
