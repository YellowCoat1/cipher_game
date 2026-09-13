local Screen = require('screens.Screen')
local node = require('node')
local camera = require 'camera'

local focused_ratio = 2/3 -- where on the screen smth should be

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
	node_list:insert_connection(1, 2, false)
	node_list:insert_connection(1, 3, true)
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
		local x_offset = 0
		if node_list:completed() then
			local connections = node_list:connections_from(node_list.active_node)
			local total = #connections
			local selected = 1
			for i,connection in ipairs(connections) do
				if connection[3] then
					selected=i
				end
			end
			if total > 1 then
				x_offset = Lerp(-50, 50, (selected-1)/(total-1))
			else
				x_offset = 0
			end
		end
		if focused_node then
			cam:lockPosition(focused_node.x + x_offset, focused_ratio*focused_node.y, damped)
		end
	end

	function self:keyreleased(key)
		node1:keyreleased(key)
	end
	return self
end

return game
