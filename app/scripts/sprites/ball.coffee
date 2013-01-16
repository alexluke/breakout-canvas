define [
    'sprite'
], (Sprite) ->
    class Ball extends Sprite
        constructor: (@x, @y) ->
            @texture = Ball.texture
            super()

            @speed =
                x: 0
                y: 0

        launch: ->
            @speed.y = -5

    Ball.texture = document.getElementById 'ball'

    return Ball
