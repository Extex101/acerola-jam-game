---@class AI
---@field aim Prop
AI = Object:extend()

---@class routineDef
---@field timer table
AI("lounge", 100, {
    {0.1, "bedroom1_bookshelf"},
    {0.2, "lounge_chair"},
    {0.5, "lounge_door_bedroom1"}
})
---Create new AI
---comment
---@param room string
---@param x number 
---@param routine routineDef
function AI:new(room, x, routine)
   self.room = room or "bedroom1"
   self.preRoom = ""
   self.x = x or 300
   self.px = self.x
   self.hidden = false
   self.path = {"lounge_door_bedroom1", "bedroom1_bookshelf", "bedroom1_door_lounge", "lounge_bookshelf"}
   self.pathIndex = 1
   self.aim = {}
   self.target = "bedroom1_bookshelf"
   -- self:findPath()
   self.player = false
   print(self.target)
end

local function nameDetails(name)
   local chunks = {}
   for word in name:gmatch("([^_]+)") do
     table.insert(chunks, word)
   end
   return chunks
 end
 
function pathfind(start, target, preRooms)
   preRooms = preRooms or {{room = ""}}
   local doors = {}
 
   for name, prop in pairs(rooms[start].props) do
     if name == target then
       table.insert(doors, name)
       return doors, target
     end
 
     local details = nameDetails(name)
 
     if details[2] == "door" and details[3] ~= preRooms[#preRooms].room then
       table.insert(doors, name)
       table.insert(preRooms, {room = start, door = name})
      
       local result, found = pathfind(details[3], target, preRooms)
 
       if found == target then
         for _, door in ipairs(result) do
           table.insert(doors, door)
         end
         return doors, found
       end
     end
   end
   PRINT("-!- ERROR!")
   return doors, false
 end

function AI:findPath()
   self.path = pathfind(self.room, self.target, {{room=self.preRoom}})
   print("Path found: ")
   for _, name in ipairs(self.path) do
      print(_..". "..name)
   end
end

function AI:walkPath()
   print("walking to: "..self.path[self.pathIndex])
   local prop = rooms[self.room].props[self.path[self.pathIndex]]
   -- self.walking = true
   self.aim = prop
   return self.path[self.pathIndex]
end

function AI:interaction()
   if self.pathIndex >= #self.path then return end
   local prop = nameDetails(self.path[self.pathIndex])
   if prop[2] == "door" then
      print("Interaction: "..prop[3])
      self:changeRoom(prop[3], prop[3].."_"..prop[2].."_"..prop[1], self.aim.pos.x + self.aim.w/2)
      self.pathIndex = self.pathIndex + 1
      self:walkPath()
   else
      print("Interaction: Prop")
      self.pathIndex = self.pathIndex + 1
      print(self:walkPath().." prop interact")
   end
end

---Run AI controller
---@param dt number deltaTime
function AI:run(dt)
   self.px = self.x
   -- print(self.room)
   if self.aim.pos then
      --Interpolate the AI to the aim point
      --The lerp speed is clamped to a max speed, so the AI will ease out when approaching the aim point
      self.x = self.x + math.max(math.min((math.lerp(self.x, self.aim.pos.x + self.aim.w/2, 0.1)-self.x), 300*dt), -300*dt)
   end
   --If the distance from the aim is less than 5 then stop walking and interact
   if self.aim.pos then
      print(self.x..", "..self.aim.pos.x)
   end
   if self.aim.pos and math.abs(self.x - (self.aim.pos.x + self.aim.w/2)) < 5 then
      print("located")
      self:interaction()
   end
end
function AI:draw()
   love.graphics.setColor(1, 1, 0)
   love.graphics.rectangle("fill", self.x-60, 100, 120, 400)
end

function AI:changeRoom(room, door)
   self.preRoom = self.room
   self.room = room
   if door then
      print("door name: "..door)
      self.x = rooms[self.room].props[door].pos.x + rooms[self.room].props[door].w/2
   end
   print("room swap: "..self.room)
   print("previous room: "..self.preRoom)
end
return AI
