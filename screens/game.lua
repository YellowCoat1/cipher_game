local Screen = require('screens.Screen')
local node = require('node')

local game = {}
function game.new()
	local self = Screen:new()

	local node1 = node(love.graphics.getWidth()/2, 2*love.graphics.getHeight()/3)

	function self:draw()
		love.graphics.push()
		node1:draw()
		love.graphics.pop()
	end

	function self:update(dt)
		node1:update(dt)
	end

	function self:keyreleased(key)
		node1:keyreleased(key)
	end
	return self
end

return game
