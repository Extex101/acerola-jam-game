Game = {}

Game.AIs = {AI("lounge", -40, {
   target = "bedroom1_bookshelf"
})}

function Game.update(dt)
    Timer.update(dt)
    UI:run()
    clicked = false
    keyReleased = {}
    keyPrePressed = keyPressed
end

---Universal Check for if the user can Click( Move ) to the current mouseCoordinates
---@return boolean
function Game.canClick()
    if UI.visible then return false end
    return true
end

function Game.inputs()
    function love.mousepressed(x, y, button, isTouch)
      if not Game.canClick(x, y) then goto noClick end
      player:click(Camera:worldCoords(x, y))
      if button == 2 then
         Game.AIs[1].pathIndex = 1
         Game.AIs[1]:walkPath()
      end
      ::noClick::
     end
     
     function love.mousereleased(x, y, button, isTouch)
        clicked = true
     end
     
     
     function love.keypressed(key, scancode, isrepeat)
        keyPressed[key] = true
     end
     
     function love.keyreleased(key)
        keyPressed[key] = false
        keyReleased[key] = true
     end
     
end
return Game