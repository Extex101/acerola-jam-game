UI = {}
local canvasWidth = love.graphics.getWidth()
local canvasHeight = love.graphics.getHeight()


local function drawCenteredText(rectX, rectY, rectWidth, rectHeight, text, align, rot)
    local font = love.graphics.getFont()
	local _, lines = font:getWrap(text, rectWidth)
    -- print(print_table(lines))
	local textHeight = font:getHeight()*#lines
	love.graphics.printf(text, math.floor(rectX), math.floor(rectY+rectHeight/2-textHeight/2), rectWidth, align, rot or 0)
end

---@class Text
---@field text string
---@field pos table
---@field align string
---@field col number
---@field rot number
Text = Object:extend()
---comment
---@param x number
---@param y number
---@param text string
---@param align string
---@param col number
---@param rot number
function Text:new(x, y, text, align, col, rot)
    self.pos = Vector(x, y)
    self.text = text or ""
    self.align = align or "center"
    self.col = col or 1
    if not col then self.col = 1 end
    self.rot = rot or 0
end

function Text:draw()
    love.graphics.setColor(self.col, self.col, self.col)
    love.graphics.printf(self.text, self.pos.x, self.pos.y, canvasWidth, self.align, self.rot)
end

function Text:setPos(vec)
    self.pos = vec
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

function Text:setPos(vec)
    self.pos = vec
end

function Button:draw()
    if self:over() then
        love.graphics.setColor(1, 0.9, 0.9, 0.1)
        love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.size.x, self.size.y)
    end
    if self.text then
        love.graphics.setColor(1, 1, 1)
        drawCenteredText(self.pos.x, self.pos.y, self.size.x, self.size.y, self.text, "center", 0)
    end
end
function Button:over()
    if over(self.pos.x, self.pos.y, self.size.x, self.size.y, love.mouse.getX(), love.mouse.getY()) then
        return true
    end
    return false
end

function Button:setPos(vec)
    self.pos = vec
end

function Button:left(vec)
    return vec:clone()
end

function Button:right(vec)
    return vec:clone() + Vector(self.size.x, 0)
end

function Button:top(vec)
    return vec:clone()
end

function Button:bottom(vec)
    return vec:clone() + Vector(0, self.size.y)
end

UI.visible = false
UI.images = {}
UI.buttons = {}
UI.text = {}


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
            UI.buttons[index] = Button(0, 0, buttonDef.w*def.scale, buttonDef.h*def.scale, buttonDef.func, buttonDef.image, buttonDef.text)
            local x = math.lerp(pos.x, limit.x, buttonDef.x/UI.images[def.background]:getWidth())
            local y = math.lerp(pos.y, limit.y, buttonDef.y/UI.images[def.background]:getHeight())
            UI.buttons[index]:setPos(Vector(x, y))
        end
    end
    if UI.content.text then
        for index, textDef in ipairs(UI.content.text) do
            local x = math.lerp(pos.x, limit.x, textDef.x/UI.images[def.background]:getWidth())
            local y = math.lerp(pos.y, limit.y, textDef.y/UI.images[def.background]:getHeight())
            UI.text[index] = Text(x, y, textDef.text, textDef.align, textDef.col, math.rad(textDef.rot))
        end
    end
end

function UI.remove()
    UI.visible = false
    UI.content = {}
    UI.buttons = {}
    UI.text = {}
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

        love.graphics.setColor(0, 0, 0, UI.content.bg)
        love.graphics.rectangle("fill", 0, 0, canvasWidth, canvasHeight)

        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(UI.image(content.background), pos.x, pos.y, 0, content.scale, content.scale)
        love.graphics.ellipse("fill", center.x, center.y, 10, 10)
        love.graphics.setColor(1, 1, 1)
        for _, button in ipairs(UI.buttons) do
            button:draw()
        end
        for _, text in ipairs(UI.text) do
            text:draw()
        end
        -- if UI.content.text then
        --     for index, textDef in ipairs(UI.content.text) do
        --         local x = math.lerp(pos.x, limit.x, textDef.x/UI.images[content.background]:getWidth())
        --         local y = math.lerp(pos.y, limit.y, textDef.y/UI.images[content.background]:getHeight())
        --         print(textDef.text, x, y, math.huge, textDef.align or "center", textDef.rot or 0)
        --         love.graphics.printf(textDef.text, 300, 300, canvasWidth, textDef.align or "center", textDef.rot or 0)
        --     end
        -- end
    end
end

function UI:run()
    if UI.visible and UI.content then
        local center = Vector(canvasWidth/2, canvasHeight/2)
        local scale = UI.content.bgDimensions
        local pos = center - (scale/2)
        if not over(pos.x, pos.y, scale.x, scale.y, love.mouse.getX(), love.mouse.getY()) and clicked then
            UI.remove()
        end
        for _, button in ipairs(UI.buttons) do
            button:run()
        end
    end
end