local screen = require 'screens.Screen'
local colors = require 'colors'
local button = require 'button'

local coal_color = colors.coal_color
local settings = {}

local line = love.graphics.line

function settings.new()
	local self = screen:new()
	local exit_button = button.new(1, 1, 1, 1)

	function self:exit_button_calc()
		local width, height = love.graphics.getDimensions()
		exit_button.x = width*(4/5) - 80
		exit_button.y = height*(4/5) - 80
		exit_button.width = 50
		exit_button.height = 50
	end

	function exit_button.draw()
		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.rectangle("line", exit_button.x, exit_button.y, exit_button.width, exit_button.height)
		line(exit_button.x + 10, exit_button.y + 10, exit_button.x+exit_button.width - 10, exit_button.y+exit_button.width - 10)
		line(exit_button.x + exit_button.width - 10, exit_button.y+10, exit_button.x + 10, exit_button.y + exit_button.height - 10)
		if exit_button.pressed then
			love.graphics.setColor(0, 0, 0, 0.4)
			love.graphics.rectangle("fill", exit_button.x, exit_button.y, exit_button.width, exit_button.height)
		end
	end

	function exit_button.trigger()
		ScreenManager.publish("settings_exit")
	end

	self:exit_button_calc()

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
		exit_button:draw()
	end

	function self:update()

	end

	function self:keypressed()

	end

	function self:keyreleased()

	end

	function self:mousepressed(x, y, m)
		exit_button:mousepressed(x, y, m)
	end

	function self:mousereleased(x, y, m)
		exit_button:mousereleased(x, y, m)
	end

	return self
end

return settings
