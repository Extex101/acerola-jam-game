function print_table(node)
   -- to make output beautiful
   local function tab(amt)
      local str = ""
      for i=1,amt do
         str = str .. "\t"
      end
      return str
   end

   local cache, stack, output = {},{},{}
   local depth = 1
   local output_str = "{\n"

   while true do
      local size = 0
      for k,v in pairs(node) do
         size = size + 1
      end

      local cur_index = 1
      for k,v in pairs(node) do
         if (cache[node] == nil) or (cur_index >= cache[node]) then

            if (string.find(output_str,"}",output_str:len())) then
               output_str = output_str .. ",\n"
            elseif not (string.find(output_str,"\n",output_str:len())) then
               output_str = output_str .. "\n"
            end

            -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
            table.insert(output,output_str)
            output_str = ""

            local key
            if (type(k) == "number" or type(k) == "boolean") then
               key = "["..tostring(k).."]"
            else
               key = "['"..tostring(k).."']"
            end

            if (type(v) == "number" or type(v) == "boolean") then
               output_str = output_str .. tab(depth) .. key .. " = "..tostring(v)
            elseif (type(v) == "table") then
               output_str = output_str .. tab(depth) .. key .. " = {\n"
               table.insert(stack,node)
               table.insert(stack,v)
               cache[node] = cur_index+1
               break
            else
               output_str = output_str .. tab(depth) .. key .. " = '"..tostring(v).."'"
            end

            if (cur_index == size) then
               output_str = output_str .. "\n" .. tab(depth-1) .. "}"
            else
               output_str = output_str .. ","
            end
         else
            -- close the table
            if (cur_index == size) then
               output_str = output_str .. "\n" .. tab(depth-1) .. "}"
            end
         end

         cur_index = cur_index + 1
      end

      if (#stack > 0) then
         node = stack[#stack]
         stack[#stack] = nil
         depth = cache[node] == nil and depth + 1 or depth - 1
      else
         break
      end
   end

   -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
   table.insert(output,output_str)
   output_str = table.concat(output)

   print(output_str)
end

function math.lerp(a, b, amt)
   return (1 - amt) * a + amt * b
end

function math.map(value, in_min, in_max, out_min, out_max)
   return (value - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

function over(x, y, w, h, mx, my)

   if mx > x  and mx < x + w then
      if my > y and my < y + h then
         return true
      end
   end
   return false
end

---https://love2d.org/forums/viewtopic.php?t=11752
function boxSegmentIntersection(l,t,w,h, x1,y1,x2,y2)
  local dx, dy  = x2-x1, y2-y1

  local t0, t1  = 0, 1
  local p, q, r

  for side = 1,4 do
    if     side == 1 then p,q = -dx, x1 - l
    elseif side == 2 then p,q =  dx, l + w - x1
    elseif side == 3 then p,q = -dy, y1 - t
    else                  p,q =  dy, t + h - y1
    end

    if p == 0 then
      if q < 0 then return nil end  -- Segment is parallel and outside the bbox
    else
      r = q / p
      if p < 0 then
        if     r > t1 then return nil
        elseif r > t0 then t0 = r
        end
      else -- p > 0
        if     r < t0 then return nil
        elseif r < t1 then t1 = r
        end
      end
    end
  end

  local ix1, iy1, ix2, iy2 = x1 + t0 * dx, y1 + t0 * dy,
                             x1 + t1 * dx, y1 + t1 * dy

  if ix1 == ix2 and iy1 == iy2 then return ix1, iy1 end
  return ix1, iy1, ix2, iy2
end

---Function to load all files with a specific extension from a folder
---@param folder string
---@param extension string
---@return table
function loadFilesWithExtension(folder, extension)
   local files = {}

   -- Get a list of items in the specified folder
   local items = love.filesystem.getDirectoryItems(folder)

   -- Iterate over each item
   for _, item in ipairs(items) do
      local fullPath = folder .. "/" .. item
      -- Check if it's a file with the specified extension
      if love.filesystem.getInfo(fullPath, "file") and item:match("%"..extension.."$") then
         -- Read the content of the file and add it to the list
         local content, size = love.filesystem.read(fullPath)
         if content then
            files[string.sub(item, 1, -string.len(extension))] = content
         else
            print("Failed to read file: " .. fullPath)
         end
      end
   end

   return files
end

function math.distance( x1, y1, x2, y2 )
	return math.sqrt( (x2-x1)^2 + (y2-y1)^2 )
end

function collisionDetect(one, two)

   -- Collision detector. Objects used must have variables t(op), b(ottom), l(eft), r(ight). Which must be updated after movement and before collisions are detected

   -- In addition the old positions must be updated before any movement is calculated. oL, or, oT, oB

   if one.b < two.t or one.t > two.b or one.l > two.r or one.r < two.l then
      return false
   end
   if one.r >= two.l and one.oR < two.oL then
      return {x = 1, y = 0}
   elseif one.l <= two.r and one.oL > two.oR then
      return {x = -1, y = 0}
   elseif one.b >= two.t and one.oT < two.oB then
      return {x = 0, y = 1}
   elseif one.t <= two.b and one.oT > two.oB then
      return {x = 0, y = -1}
   end
   return false

   --returns an x, y detailing which side of object 'one' collided
end

function fill(r, g, b, a)
   if type(r) == "table" then
      a = r[4] or 100
      if g then
         a = g
         if g < 1 then
            a = g*100
         end
      end
      b = r[3] or 0
      g = r[2] or 0
      r = r[1]
   end
   if not a then a = 100 end
   love.graphics.setColor(r/100, g/100, b/100, a/100)
end

Jump = Object:extend()

function Jump:new(height, time, delta)
   local g = (2 * height) / math.pow(time, 2.0)
   local jv = -math.sqrt(2 * g * height)
   g = g * delta
   self.gravity = g
   self.jumpSpeed = jv
end
