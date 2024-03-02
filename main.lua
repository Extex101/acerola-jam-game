io.stdout:setvbuf("no")

function love.conf(t)
	t.console = true
end

function love.load(arg)
   require("init")
   Game.inputs()
end

function love.update(dt)
   player:run(dt)
   Game.update()
end

function love.draw()
   Camera:attach()
   player:draw()
   Camera:detach()
   UI.draw()
end
