local fullscreen = {}

local x, y, width, height
local font

function fullscreen.init()
	font = love.graphics.newFont(FontName, 16)
	fullscreen.calc()
end

function fullscreen.calc()
	x = 10
	y = love.graphics.getHeight() - 60
	width = font:getWidth("fullscreen") + 20
	height = font:getHeight() + 10
end

function fullscreen.draw()
	love.graphics.setColor(0.4, 0.4, 0.6, 1)
	love.graphics.rectangle("fill", x, y, width, height)
	love.graphics.setColor(0.1, 0.1, 0.1, 1)
	love.graphics.print("fullscreen", font, x+10, y+5)
end

function fullscreen.mousepressed(mx, my, m)
	if m == 1 and mx > x and mx < x + width and my > y and my < y + height then
		local fullscreened = love.window.getFullscreen()
		love.window.setFullscreen(not fullscreened, "exclusive")
	end
end

return fullscreen
