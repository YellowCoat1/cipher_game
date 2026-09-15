local opacity = {}

function opacity.new()
	local self = {}
	local canvas = love.graphics.newCanvas()
	self.set_opacity = 0.1

	function self:attach()
		love.graphics.setCanvas(canvas)
		love.graphics.clear()
	end
	function self:detach()
		love.graphics.setCanvas()
		love.graphics.setColor(1, 1, 1, self.set_opacity)
		love.graphics.draw(canvas)
	end

	return self
end

return opacity
