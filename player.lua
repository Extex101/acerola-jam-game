---@class Player
---@field new function
Player = Object:extend()

---Create new Player
function Player:new()
   self.room = "bedroom1"
   self.x = 500
   self.px = 300
   self.hidden = false
   self.walking = true
   self.aim = 500
   self.aimY = 0
   self.aimAnim = 0
   self.aimAnimLength = 1
   self.roomFade = 0
end
---Update Camera
function Player:cameraUpdate()
   local x = Camera:cameraCoords(self.x, 0)
   local w = love.graphics.getWidth()-200
   -- print(x, w-200)
   if x > w/2 or x < w/2 then
      Camera:lookAt(math.lerp(Camera.x, self.x, 0.05), Camera.y)
   end
   local limits = rooms[self.room].bounds
   local minx, miny = Camera:cameraCoords(rooms[self.room].bounds.min, -math.huge)
   local maxx, maxy = Camera:cameraCoords(rooms[self.room].bounds.max, math.huge)
   
   if Camera.x < limits.min then
      Camera:lookAt(limits.min, Camera.y)
   end
end

---Run player controller
---@param dt number deltaTime
function Player:run(dt)
   self.px = self.x
   if self.walking then
      --Interpolate the player to the aim point
      --The lerp speed is clamped to a max speed, so the player will ease out when approaching the aim point
      self.x = self.x + math.max(math.min((math.lerp(self.x, self.aim, 0.1)-self.x), 300*dt), -300*dt)
   end
   --If the distance from the aim is less than 5 then stop walking and interact
   if math.abs(self.x - self.aim) < 5 and self.walking then
      if self.interaction then
         self.interaction()
      end
      self.walking = false
   end
   if self.aimAnim > 0 then
      self.aimAnim = self.aimAnim - dt
   end
   for _, prop in ipairs(rooms[self.room].props) do
      if prop.click then
         prop:run()
      end
   end
   if self.roomFade > 0 then
      self.roomFade = self.roomFade - dt
   end

   self:cameraUpdate(dt)
end
function Player:draw()
   for _, prop in ipairs(rooms[self.room].props) do
      prop:draw()
   end

   love.graphics.setColor(1, 0, 0)
   love.graphics.rectangle("fill", self.x-50, 100, 100, 400)
   if self.aimAnim > 0 then
      love.graphics.setColor(1, 1, 1, self.aimAnim/self.aimAnimLength-0.2)
      local s = math.map(self.aimAnim, 0, self.aimAnimLength, 0, 45)
      love.graphics.setLineWidth(math.max(s/2 - 10, 0))
      love.graphics.ellipse("line", self.aim, self.aimY, s, s)
   end
   Camera:detach()
   if self.roomFade > 0 then
      love.graphics.setColor(0, 0, 0, self.roomFade)
      love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
   end
   Camera:attach()
end

function Player:changeRoom(room, x)
   self.room = room
   if x then
      self.x = x
      self.aim = x
      Camera:lookAt(self.x, Camera.y)
   end
   self.roomFade = 1
end


---@param x number X Coordinate
---@param y number Y Coordinate
function Player:click(x, y)
   self.aim = x
   self.aimY = y
   self.aimAnim = self.aimAnimLength
   self.walking = true
   self.interaction = false
end
return Player
