local rooms = {}
rooms.lounge = {
    bounds = {
        min = Vector(),
        max = Vector()
    },
    props = {
        Prop(400, 10, {
            w = 200,
            h = 400,
            room = "lounge",
            click = function()
                player:changeRoom("bedroom1", 300)
                print(player.room)
            end,
            texture = "textures/door.png",
        })
    }
 }



rooms.bedroom1 = {
    bounds = {
        min = Vector(),
        max = Vector()
    },
    props = {
        Prop(500, 180, {
            w = 200,
            h = 200,
            room = "lounge",
            click = function()
                UI.show({
                    background = "bookshelf.png",
                    scale = 7,
                    buttons = {
                    {
                        x=0.9, y=0.5, 
                        w=100, h=50, 
                        text = "I'm invisible, yes I truly am invisible",
                        func = function ()
                            print("Help me")
                        end
                    },
                    -- {x=0.5, y=0.5, image = "button.png", s = 2, text="button"},
                    },
                    text = {
                    {
                        x=0.9, y=0.5, 
                        text = "I'm invisible, yes I truly am invisible",
                    }
                    }
                })
            end,
            texture = "textures/bookshelf.png",
        }),
        Prop(200, 10, {
            w = 200,
            h = 400,
            room = "lounge",
            click = function()
                player:changeRoom("lounge", 500)
            end,
            texture = "textures/door.png",
        })
    }
}

return rooms