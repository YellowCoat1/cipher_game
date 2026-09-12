local Screen = require('screens.Screen')
local node = require('node')

local game = {}
function game.new()
	local self = Screen:new()

	local node1 = node(love.graphics.getWidth()/2, 2*love.graphics.getHeight()/3)
	node1.active = true
	local node2 = node(1*love.graphics.getWidth()/3, 1*love.graphics.getHeight()/3)
	node2.active = false
	local node3 = node(2*love.graphics.getWidth()/3, 1*love.graphics.getHeight()/3)
	node3.active = false
	local nodes = {node1, node2, node3}

	function self:draw()
		love.graphics.push()
		for _,single_node in ipairs(nodes) do
			single_node:draw()
		end
		love.graphics.pop()
	end

	function self:update(dt)
		for _,single_node in ipairs(nodes) do
			single_node:update(dt)
		end
	end

	function self:keyreleased(key)
		node1:keyreleased(key)
	end
	return self
end

return game
