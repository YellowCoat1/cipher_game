local Screen = require('screens.Screen')
local node = require('node')
local camera = require 'camera'

local game = {}
function game.new()
	local self = Screen:new()

	local cam = camera.new()
	local damped = camera.smooth.damped(3)


	local node_list = require('node_list')
	local node1 = node(love.graphics.getWidth()/2, 2*love.graphics.getHeight()/3)
	local node2 = node(1*love.graphics.getWidth()/3, 1*love.graphics.getHeight()/3)
	local node3 = node(2*love.graphics.getWidth()/3, 1*love.graphics.getHeight()/3)
	node_list:insert_nodes(node1, node2, node3)
	node_list:insert_connection(1, 3)
	node_list:focused_node(1)

	function self:draw()
		love.graphics.push()
		cam:attach()
		node_list:draw()
		cam:detach()
		love.graphics.pop()
	end

	function self:update(dt)
		node_list:update(dt)
		local focused_node = node_list:get_focused_node()
		if focused_node then
			cam:lockPosition(focused_node.x, focused_node.y, damped)
		end
	end

	function self:keyreleased(key)
		node1:keyreleased(key)
	end
	return self
end

return game
