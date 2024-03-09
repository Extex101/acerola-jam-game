
love.window.setMode(1200,600)
FLOOR_HEIGHT = 500
require("lib.init")
rooms = {}
player = require("player")()
Prop = require("prop")
require("gui")
rooms = require("rooms")
AI = require("ai")
clicked = false
keyReleased = {}
keyPressed = {}
keyPrePressed = {}