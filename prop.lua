---@class Prop
---@field texture spriteRef
---@field click function
---@field room string
Prop = Object:extend()

---@class Def
---@field w number
---@field h number
---@field texture string
---@field click function
---@field room string

---Create new Prop
---@param x number
---@param y number
---@param def Def
function Prop:new(x, y, def)
   self.pos = Vector(x, y)
   self.w = def.w
   self.h = def.h
   self.room = def.room
   self.click = def.click
   self.texture = spriteManager.loadImage(def.texture)
end

---Draw the prop
function Prop:draw()
   love.graphics.setColor(0.5, 0.5, 0.5)
   if self:over() then
      love.graphics.setColor(0.8, 0.8, 0.8)
   end
   self.texture:draw(self.pos.x, self.pos.y, self.w, self.h, 0)
end

---Returns true if mouse is over prop
function Prop:over()
   local mx, my = Camera:worldCoords(love.mouse.getX(), love.mouse.getY())
   if over(self.pos.x, self.pos.y, self.w, self.h, mx, my) then return true end
   return false
end

function Prop:run(dt)
   if self:over() and clicked then
      player.interaction = self.click
   end
   if self.texture.animated then
      self.texture:run(dt)
   end
end
return Prop
