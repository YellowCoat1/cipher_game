local Screen = require 'screens.Screen'
local death = {}

function death.new()
	local self = Screen:new()

	function self:draw()
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.print("You Died!", 100, 100)
	end


	return self
end

return death
