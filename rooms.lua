local rooms = {}
rooms.lounge = {
    bounds = {
        min = -40,
        max = 400
    },
    props = {
        Prop(400, 10, {
            w = 200,
            h = 400,
            room = "lounge",
            click = function()
                UI.show({
                    background = "ui_door.png",
                    scale = 12.5,
                    bg = 0.2,
                    buttons = {
                        {
                            x=12, y=22, 
                            w=13, h=5, 
                            text = "",
                            func = function ()
                                player:changeRoom("bedroom1", 300)
                                UI.remove()
                            end
                        },
                    -- {x=0.5, y=0.5, image = "button.png", s = 2, text="button"},
                    },
                    text = {
                        {
                            x=0.2, y=0.5, 
                            text = "I'm invisible, yes I truly am invisible",
                            col = 1,
                            align = "center",
                            rot = 0,
                        }
                    }
                })
                print(player.room)
            end,
            texture = "textures/door.png",
        })
    }
 }



rooms.bedroom1 = {
    bounds = {
        min = -100,
        max = 300
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
                            x=16, y=4,
                            w=4, h=10,
                            text = "K",
                            func = function ()
                                print("Help me")
                            end
                        },
                        {
                            x=26, y=4,
                            w=4, h=10,
                            text = "A",
                            func = function ()
                                print("Help me")
                            end
                        },
                        {
                            x=38, y=4,
                            w=4, h=10,
                            text = "B",
                            func = function ()
                                print("Help me")
                            end
                        },
                    -- {x=0.5, y=0.5, image = "button.png", s = 2, text="button"},
                    },
                    text = {
                        {
                            x=0.2, y=0.5, 
                            text = "I'm invisible, yes I truly am invisible",
                            col = 1,
                            align = "center",
                            rot = 0,
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