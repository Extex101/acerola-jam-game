local animations = {
   walk = {50, 100, 12},
   run = {70, 90, 6}
}

---@class spriteRef
---@field spriteSheet love.Image
---@field draw function
---@field run function
---@field sprites table
---@field timers table
---@field state string
---@field animated boolean

---@class spriteManager
---@field loadImage spriteRef

local spriteManager = {}

spriteManager.loadImage = Object:extend()


---@param img string
---@param animations table optional
---@param state string optional
function spriteManager.loadImage:new(img, animations, state)
   local yoff = 0
   local xoff = 0
   local tallestTile = 0
   self.spriteSheet = love.graphics.newImage(img, {linear = false, mipmaps = false})
   self.spriteSheet:setFilter('nearest','nearest')
   self.sprites = {}
   self.timers = {}
   self.state = state or ""
   if animations then
      self.animated = true
      for key, anim in pairs(animations) do
         local animSprites = {}
         self.timers[key] = {
            timer = 0,
            length = anim.time,
            frame = 1
         }
         for i = 1, anim.length do
            table.insert(animSprites, love.graphics.newQuad(xoff, yoff, anim.w, anim.h, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())) -- Put getQuad here

            if anim.h > tallestTile then
               tallestTile = anim.h
            end

            xoff = xoff + anim.w

            if xoff + anim.w > self.spriteSheet:getWidth() then
               xoff = 0
               yoff = yoff + tallestTile
               tallestTile = 0
            end
         end

         self.sprites[key] = animSprites
      end
   else
      self.animated = false
   end
end

---Draw the sprite. spriteRef:run(dt) to animate
---@param x number
---@param y number
---@param w number
---@param h number
---@param r number
function spriteManager.loadImage:draw(x, y, w, h, r)
   if self.animated then
      local frame = self.timers[self.state].frame
      love.graphics.draw(self.spriteSheet, self.sprites[self.state][frame], x, y, r, w, h)
   else
      love.graphics.draw(self.spriteSheet, x, y, r, (1/self.spriteSheet:getWidth())*w, (1/self.spriteSheet:getHeight())*h)
   end

end

function spriteManager.loadImage:run(dt)
   local timer = self.timers[self.state]
   local sprite = self.sprites[self.state]
   self.timers[self.state].timer = self.timers[self.state].timer + dt
   if timer.timer > (timer.length/#sprite) * timer.frame then
      timer.frame = timer.frame + 1
   end
   if timer.timer > timer.length then
      timer.frame = 1
      timer.timer = 0
   end
end

function spriteManager.loadImage:setState(state)


end

function spriteManager.loadImage:restartAnim()

end
return spriteManager
