local button = {}

local function inRectangle(x, y, rect)
	if x > rect.x and x < rect.x + rect.width and y > rect.y and y < rect.y + rect.height then
		return true
	else
		return false
	end
end


function button.new(x, y, width, height)
	local self = {}
	self.x = x
	self.y = y
	self.width = width
	self.height = height

	function self:mousepressed(mx, my, m)
		if inRectangle(mx, my, self) and m == 1 then
			self.pressed = true
		end
	end

	function self:mousereleased(mx, my, m)
		if inRectangle(mx, my, self) and self.pressed and m == 1 then
			(self.trigger or function() end)()
		elseif self.pressed and m == 1 then
			self.pressed = false
		end
	end

	function self.draw() end

	return self
end


return button
