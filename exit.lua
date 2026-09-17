local exit = {}

-- ranges from 0 to 1, 1 is exit
exit.timer = 0

local canvas
local font
function exit.load()
	canvas = love.graphics.newCanvas()
	font = love.graphics.newFont(25)
end

local triggered = false

function exit.draw()
	if triggered then return end
	love.graphics.setCanvas(canvas)
	if exit.timer == 0 then
		love.graphics.clear()
		love.graphics.setCanvas()
		return
	end
	love.graphics.setColor(0, 0, 0, 1)

	-- draw a little circle
	local sin, cos = math.sin((math.pi*exit.timer*2)-(math.pi/2)), math.cos((math.pi*exit.timer*2)-(math.pi/2))
	local startx, starty = 70, 70
	local radius, border = 40, 5
	love.graphics.line(startx+cos*radius, starty+sin*radius, startx+cos*(radius+border), starty+sin*(radius+border))

	love.graphics.setCanvas()
	love.graphics.print("exit", font, startx-(font:getWidth("exit")/2), starty-(font:getHeight()/2))
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(canvas, 0, 0)

end

function exit.update(dt)
	local active_name = ScreenManager.peek().name
	if active_name == "main menu" or active_name == "settings" then return end
	if love.keyboard.isDown('escape') and not triggered then
		exit.timer = exit.timer + (1/3)*dt
	else
		exit.timer = 0
		if not love.keyboard.isDown('escape') then
			triggered = false
		end
	end

	if exit.timer >= 1 then
		ScreenManager.publish("exit_to_main")
		if GameMusic then GameMusic:stop() end
		triggered = true
	end
end

return exit
