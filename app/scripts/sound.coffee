define ->
    class Sound
        @maxChannels = 4
        @loadedSounds = {}
        @soundPath = 'sounds/'

        @load: (name) ->
            new Audio @soundPath + name + '.wav'

        @play: (name) ->
            if not @loadedSounds[name]
                @loadedSounds[name] = [@load name]

            freeChannels = (channel for channel in @loadedSounds[name] when channel.currentTime == channel.duration or channel.currentTime == 0)

            if freeChannels.length > 0
                channel = freeChannels[0]
                try
                    channel.currentTime = 0
                catch e
                channel.play()
            else if @loadedSounds[name].length < @maxChannels
                sound = @load name
                @loadedSounds[name].push sound
                sound.play()
                
