local rooms = {}
rooms.lounge = {
    bounds = {
        min = -40,
        max = 400
    },
    props = {
        lounge_bookshelf = Prop(0, 180, {
            w = 200,
            h = 200,
            click = function(user)
                if not user.player then return end
                UI.show({
                    background = "bookshelf.png",
                    scale = 7,
                    buttons = {
                        {
                            x=16, y=4,
                            w=4, h=10,
                            func = function ()
                                print("Help me")
                            end
                        },
                        {
                            x=26, y=4,
                            w=4, h=10,
                            func = function ()
                                print("Help me")
                            end
                        },
                        {
                            x=38, y=4,
                            w=4, h=10,
                            func = function ()
                                print("Help me")
                            end
                        },
                    -- {x=0.5, y=0.5, image = "button.png", s = 2, text="button"},
                    },
                    text = {
                        {
                            x=19, y=5, 
                            text = "Cool Book",
                            col = 1,
                            align = "left",
                            rot = 90,
                        },
                        {
                            x=29, y=5.5, 
                            text = "Bad Book",
                            col = 0,
                            align = "left",
                            rot = 90,
                        }
                    }
                })
            end,
            texture = "textures/bookshelf.png",
        }),
        lounge_door_bedroom1 = Prop(400, 10, {
            w = 200,
            h = 400,
            room = "lounge",
            click = function(user)
                if user.player then
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
                                    user:changeRoom("bedroom1", 300)
                                    UI.remove()
                                end
                            },
                        -- {x=0.5, y=0.5, image = "button.png", s = 2, text="button"},
                        },
                    })
                else
                    user:changeRoom("bedroom1", 300)
                end
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
        bedroom1_bookshelf = Prop(500, 180, {
            w = 200,
            h = 200,
            click = function(user)
                if not user.player then
                    -- print("interact")
                    -- local p = pathfind(user.start, "lounge_bookshelf")
                    -- print_table(p)
                    -- user.target = "lounge_bookshelf"
                    -- user.aim = user.aim - 100
                    -- user:findPath()
                    return true
                end
                UI.show({
                    background = "bookshelf.png",
                    scale = 7,
                    buttons = {
                        {
                            x=16, y=4,
                            w=4, h=10,
                            func = function ()
                                print("Help me")
                            end
                        },
                        {
                            x=26, y=4,
                            w=4, h=10,
                            func = function ()
                                print("Help me")
                            end
                        },
                        {
                            x=38, y=4,
                            w=4, h=10,
                            func = function ()
                                print("Help me")
                            end
                        },
                    -- {x=0.5, y=0.5, image = "button.png", s = 2, text="button"},
                    },
                    text = {
                        {
                            x=19, y=5, 
                            text = "Cool Book",
                            col = 1,
                            align = "left",
                            rot = 90,
                        },
                        {
                            x=29, y=5.5, 
                            text = "Bad Book",
                            col = 0,
                            align = "left",
                            rot = 90,
                        }
                    }
                })
            end,
            texture = "textures/bookshelf.png",
        }),
        bedroom1_door_lounge = Prop(200, 10, {
            w = 200,
            h = 400,
            room = "lounge",
            click = function(user)
                user:changeRoom("lounge", 500)
            end,
            texture = "textures/door.png",
        })
    }
}

return rooms