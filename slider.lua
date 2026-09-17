local slider = {}
local colors = require 'colors'

local function inRectangle(x, y, rect)
	if x > rect.x and x < rect.x + rect.width and y > rect.y and y < rect.y + rect.height then
		return true
	else
		return false
	end
end


local coal_color = colors.coal_color
local cipher_secondary_color = colors.cipher_secondary_color

function slider.new(x, y, width, height, p)
	local self = {}
	self.slider_percent = p or 0.5
	self.x, self.y = x, y
	self.width, self.height = width, height

	function self:draw()
		--love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
		local p_len = self.width*(self.slider_percent)
		love.graphics.setColor(colors.with_opacity(cipher_secondary_color, 0.4))
		love.graphics.rectangle("fill", self.x, self.y, p_len, self.height)
		love.graphics.setLineWidth(5)
		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	end

	function self:mousepressed(xm, ym, m)
		if inRectangle(xm, ym, self) and m == 1 then
			self.pressed = true
		end
	end

	function self:p_from_x(x_val)
		x_val = math.max(self.x, x_val)
		x_val = math.min(self.x+self.width, x_val)
		self.slider_percent = (x_val - self.x)/(self.width)
	end

	function self:update()
		if self.pressed then
			local mx, _ = love.mouse.getPosition()
			self:p_from_x(mx)
		end
	end

	function self:mousereleased(_, _, m)
		if self.pressed and m == 1 then
			self.pressed = false
		end
	end

	return self
end

return slider
