UI = {}


local function drawCenteredText(rectX, rectY, rectWidth, rectHeight, text, align, rot)
    local font = love.graphics.getFont()
	local _, lines = font:getWrap(text, rectWidth)
    -- print(print_table(lines))
	local textHeight = font:getHeight()*#lines
	love.graphics.printf(text, math.floor(rectX), math.floor(rectY+rectHeight/2-textHeight/2), rectWidth, align, rot or 0)
end

Text = Object:extend()
function Text:new(x, y, w, h, text, align, col, rot)
    self.pos = Vector(x, y)
    self.text = text or ""
    self.align = align "center"
    self.col = col or 0
    self.rot = rot or 0
end

function Text:draw()
    local pos = self.pos - (self.size/2)
    love.graphics.setColor(self.col, self.col, self.col)
    love.graphics.printf(self.text, pos.x, pos.y, math.huge, self.align, self.rot)
end
function Text:over()
    local pos = self.pos - (self.size/2)
    if over(pos.x, pos.y, self.size.x, love.mouse.getX(), love.mouse.getY()) then
        return true
    end
    return false
end

function Text:setPos(vec)
    self.pos = vec
end

function Text:left(vec)
    return vec:clone() - Vector(self.size.x/2, 0)
end

function Text:right(vec)
    return vec:clone() + Vector(self.size.x/2, 0)
end

function Text:top(vec)
    return vec:clone() - Vector(0, self.size.y/2)
end

function Text:bottom(vec)
    return vec:clone() + Vector(0, self.size.y/2)
end

Button = Object:extend()

function Button:new(x, y, w, h, func, image, text)
    self.pos = Vector(x, y)
    self.size = Vector(w, h)
    self.func = func
    self.image = image
    self.text = text
end

function Button:run()
    if self:over() and clicked then
        self.func(self)
    end
end

function Button:draw()
    local pos = self.pos - (self.size/2)
    if self:over() then
        love.graphics.setColor(1, 0.9, 0.9, 0.1)
        love.graphics.rectangle("fill", pos.x, pos.y, self.size.x, self.size.y)
    end
    if self.text then
        love.graphics.setColor(1, 1, 1)
        drawCenteredText(pos.x, pos.y, self.size.x, self.size.y, self.text, "center", 0)
    end
end
function Button:over()
    local pos = self.pos - (self.size/2)
    if over(pos.x, pos.y, self.size.x, self.size.y, love.mouse.getX(), love.mouse.getY()) then
        return true
    end
    return false
end

function Button:setPos(vec)
    self.pos = vec
end

function Button:left(vec)
    return vec:clone() - Vector(self.size.x/2, 0)
end

function Button:right(vec)
    return vec:clone() + Vector(self.size.x/2, 0)
end

function Button:top(vec)
    return vec:clone() - Vector(0, self.size.y/2)
end

function Button:bottom(vec)
    return vec:clone() + Vector(0, self.size.y/2)
end

UI.visible = false
UI.images = {}
UI.buttons = {}


local canvasWidth = love.graphics.getWidth()
local canvasHeight = love.graphics.getHeight()
-- Get a list of items in the specified folder
local items = love.filesystem.getDirectoryItems("/ui")

-- Iterate over each item
for _, name in ipairs(items) do
    local fullPath = "/ui/" .. name
    -- Check for png
    if name:match("%.png$") then
        -- Load the images and add them to the list
        UI.images[name] = love.graphics.newImage(fullPath)
        UI.images[name]:setFilter('nearest','nearest')
    end
end

--Todo:
--load all UI images and store them

---Create new UI element
---@param def table
function UI.show(def)
    def.background = def.background or "ui_background.png"
    if not UI.images[def.background] then
        print(def.background.." not found. Fallback to 'ui_background.png'.")
        def.background = "ui_background.png"
    end
    def.bgDimensions = Vector(UI.images[def.background]:getWidth(), UI.images[def.background]:getHeight()) * def.scale
    UI.content = def
    UI.visible = true
    local center = Vector(canvasWidth/2, canvasHeight/2)
    local scale = UI.content.bgDimensions
    local pos = center - (scale/2)
    local limit = center + (scale/2)
    if UI.content.buttons then
        for index, buttonDef in ipairs(UI.content.buttons) do
            UI.buttons[index] = Button(0, 0, buttonDef.w, buttonDef.h, buttonDef.func, buttonDef.image, buttonDef.text)
            local x = math.lerp(UI.buttons[index]:right(pos).x, UI.buttons[index]:left(limit).x, buttonDef.x)
            local y = math.lerp(UI.buttons[index]:bottom(pos).y, UI.buttons[index]:top(limit).y, buttonDef.y)
            UI.buttons[index]:setPos(Vector(x, y))
        end
    end
end

function UI.remove()
    UI.visible = false
    UI.content = {}
    UI.buttons = {}
end

function UI.image(id)
    return UI.images[id]
end
function UI.draw()
    if UI.visible and UI.content then
        local content = UI.content
        local center = Vector(canvasWidth/2, canvasHeight/2)
        local scale = UI.content.bgDimensions
        local pos = center - (scale/2)
        local limit = center + (scale/2)

        fill(0, 0, 0, 60)
        love.graphics.rectangle("fill", 0, 0, canvasWidth, canvasHeight)

        fill(100, 100, 100)
        love.graphics.draw(UI.image(content.background), pos.x, pos.y, 0, content.scale, content.scale)
        love.graphics.ellipse("fill", center.x, center.y, 10, 10)
        love.graphics.setColor(1, 1, 1)
        for index, button in ipairs(UI.buttons) do
            button:draw(love.mouse.getPosition())
        end
    end
end

function UI:run()
    if UI.visible and UI.content then
        local content = UI.content
        local center = Vector(canvasWidth/2, canvasHeight/2)
        local scale = UI.content.bgDimensions
        local pos = center - (scale/2)
        if not over(pos.x, pos.y, scale.x, scale.y, love.mouse.getX(), love.mouse.getY()) and clicked then
            UI.remove()
        end
        for index, button in ipairs(UI.buttons) do
            button:run()
        end
    end
end