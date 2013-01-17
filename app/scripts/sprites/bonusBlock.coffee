define [
    'sprite'
    'sprites/block'
], (Sprite, Block) ->
    class BonusBlock extends Block
        @multiplier = 5
        @upgrade: (block) ->
            bonus = new BonusBlock block.x, block.y
            bonus.points = block.points * @multiplier
            return bonus

        constructor: (@x, @y) ->
            super(@x, @y)
            @texture = BonusBlock.texture

        downgrade: ->
            points = @points / BonusBlock.multiplier
            if points > Block.points
                block = new BonusBlock @x, @y
            else
                block = new Block @x, @y
            block.points = points
            return block

        draw: (ctx) ->
            super(ctx)
            ctx.save()
            multiBonus = 0
            points = @points
            while points > Block.points
                multiBonus++
                points /= BonusBlock.multiplier
            ctx.globalAlpha = 0.2 + 0.1 * multiBonus
            ctx.fillStyle = 'rgb(255, 0, 0)'
            ctx.fillRect @x, @y, @width, @height
            ctx.restore()

