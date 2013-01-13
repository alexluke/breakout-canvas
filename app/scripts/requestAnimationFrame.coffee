define ->
    window.requestAnimationFrame or
        window.webkitRequestAnimationFrame or
        window.mozRequestAnimationFrame or
        window.oRequestAnimationFrame or
        window.msRequestAnimationFrame or
        (callback) ->
            window.setInterval callback, 1000 / 60
