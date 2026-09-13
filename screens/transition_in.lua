local Screen = require("screens.Screen")

local transition_in = {}


function transition_in.new()
	local self = Screen:new()
	self.darknessPercent = 1
	local transition_done = false
	local transition_seconds = 3

	function self:update(dt)
		self.darknessPercent = self.darknessPercent - (1/transition_seconds)*dt
		if self.darknessPercent <= 0 and not transition_done then
			ScreenManager.publish("transition_in_done")
			ScreenManager.pop()
			transition_done = true
		end
	end

	function self:draw()
		local opacity = math.max(self.darknessPercent, 0)
		love.graphics.setColor(0, 0, 0, opacity)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	end

	return self
end
return transition_in
