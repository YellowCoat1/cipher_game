local screen = require 'screens.Screen'
local colors = require 'colors'

local coal_color = colors.coal_color
local cipher_main_color = colors.cipher_main_color
local settings = {}

local function inRectangle(x, y, rect)
	if x > rect.x and x < rect.x + rect.width and y > rect.y and y < rect.y + rect.height then
		return true
	else
		return false
	end

end



local line = love.graphics.line
function settings.new()
	local self = screen:new()

	function self:draw()
		love.graphics.setColor(colors.with_opacity(coal_color, 0.95))
		local width, height = love.graphics.getDimensions()
		love.graphics.rectangle("fill", width*(1/5), height*(1/5), width*(3/5), height*(3/5))
		love.graphics.setColor(0, 0, 0, 1)
		local line_width = 5
		love.graphics.setLineWidth(line_width)
		line(width*(1/5), height*(1/5), width*(4/5)+line_width/2, height*(1/5))
		line(width*(4/5), height*(1/5), width*(4/5), height*(4/5)+line_width/2)
		line(width*(1/5), height*(4/5), width*(4/5)+line_width/2, height*(4/5))
		line(width*(1/5), height*(1/5)-line_width/2, width*(1/5), height*(4/5)+line_width/2)
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.setLineWidth(1)
		--love.graphics.print("settings", love.graphics.getWidth()/2, love.graphics.getHeight()/2)
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
