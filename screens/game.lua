local Screen = require('screens.Screen')
local node = require('node')

local game = {}
function game.new()
	local self = Screen:new()

	local node_list = require('node_list')
	local node1 = node(love.graphics.getWidth()/2, 2*love.graphics.getHeight()/3)
	local node2 = node(1*love.graphics.getWidth()/3, 1*love.graphics.getHeight()/3)
	local node3 = node(2*love.graphics.getWidth()/3, 1*love.graphics.getHeight()/3)
	node_list:insert_nodes(node1, node2, node3)
	node_list:insert_connection(1, 3)
	node_list:focused_node(1)

	function self:draw()
		love.graphics.push()
		node_list:draw()
		love.graphics.pop()
	end

	function self:update(dt)
		node_list:update(dt)
	end

	function self:keyreleased(key)
		node1:keyreleased(key)
	end
	return self
end

return game
