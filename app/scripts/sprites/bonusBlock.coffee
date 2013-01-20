define [
    'sprite'
    'sprites/block'
], (Sprite, Block) ->
    class BonusBlock extends Block
        @upgrade: (block) ->
            return block if block.points > Block.points
            bonus = new BonusBlock block.x, block.y, block.color
            bonus.points = block.points * 5
            return bonus

        constructor: (@x, @y, color) ->
            super(@x, @y, color)
            @texture = switch color
                when 'red' then BonusBlock.redTexture
                when 'green' then BonusBlock.greenTexture
                when 'blue' then BonusBlock.blueTexture
                else throw 'Invalid block color'

        downgrade: ->
            new Block @x, @y, @color

    BonusBlock.texture = document.getElementById 'blockBonus'
    BonusBlock.redTexture = Block.colorBlock Block.colors.red, BonusBlock.texture
    BonusBlock.greenTexture = Block.colorBlock Block.colors.green, BonusBlock.texture
    BonusBlock.blueTexture = Block.colorBlock Block.colors.blue, BonusBlock.texture

    return BonusBlock
