
love.window.setMode(1200,600)
FLOOR_HEIGHT = 500
require("lib.init")
require("game")

player = require("player")()
Prop = require("prop")
require("gui")
rooms = require("rooms")
clicked = false
keyReleased = {}
keyPressed = {}
keyPrePressed = {}