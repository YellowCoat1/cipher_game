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
	local node_connections = {}
	node_connections[1] = {1, 3}


	function self:draw_node_connections()
		for _, node_connection in ipairs(node_connections) do
			local nodec1, nodec2 = nodes[node_connection[1]], nodes[node_connection[2]]
			love.graphics.line(nodec1.x, nodec1.y, nodec2.x, nodec2.y)
		end
	end

	function self:draw()
		love.graphics.push()
		self:draw_node_connections()
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
