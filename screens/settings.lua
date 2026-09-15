local screen = require 'screens.Screen'
local settings = {}

function settings.new()
	local self = screen:new()
	print("owo")

	function self:draw()
		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.rectangle("fill", 200, 200, love.graphics.getWidth()-400, love.graphics.getHeight()-400)
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.print("settings", love.graphics.getWidth()/2, love.graphics.getHeight()/2)
	end

	function self:update()

	end

	function self:keypressed()

	end

	function self:keyreleased()

	end

	return self
end

return settings
