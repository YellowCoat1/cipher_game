local Screen = require("screens.Screen")

local transition_out = {}


function transition_out.new()
	local self = Screen:new()
	self.darknessPercent = 0
	self.name = "Transition Out"
	local transition_done = false
	local transition_seconds = 3

	function self:update(dt)
		self.darknessPercent = self.darknessPercent + (1/transition_seconds)*dt
		if self.darknessPercent >= 1 and not transition_done then
			ScreenManager.publish("transition_done")
			transition_done = true
		end
	end

	function self:draw()
		love.graphics.setColor(0, 0, 0, math.min(self.darknessPercent, 1))
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	end

	return self
end
return transition_out
