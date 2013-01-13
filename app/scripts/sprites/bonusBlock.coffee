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
            ctx.drawImage BonusBlock.textureOverlay, @x, @y
            ctx.restore()


    BonusBlock.textureOverlay = Sprite.createTexture Block.texture.width, Block.texture.height, (ctx) ->
        ctx.fillStyle = 'rgb(255, 0, 0)'
        ctx.fillRect 0, 0, Block.texture.width, Block.texture.height

        ctx.globalCompositeOperation = 'destination-atop'
        ctx.drawImage Block.texture, 0, 0

    return BonusBlock
