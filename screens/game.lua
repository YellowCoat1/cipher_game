local Screen = require('screens.Screen')
local node = require('node')
local camera = require 'libs.camera'
local sea_mod = require('sea')
local node_procedural = require 'node_proceduaral'

local focused_ratio = 2/3 -- where on the screen smth should be

local function initial_nodes(node_list)
	local node1 = node(0, 0, 3)
	local node2 = node(-200, -300, 3)
	local node3 = node(200, -300, 3)
	local node4 = node(-200, -600, 3)
	local node5 = node(200, -600, 3)
	node_list:insert_nodes(node1, node2, node3, node4, node5)
	node_list:insert_connection(1, 2, false)
	node_list:insert_connection(1, 3, false)
	node_list:insert_connection(2, 4, false)
	node_list:insert_connection(2, 5, false)
	node_list:insert_connection(3, 5, false)
	node_list:focused_node(1)
end

local game = {}
function game.new()
	local self = Screen:new()
	self.name = "game"

	local cam = camera.new()
	local damped = camera.smooth.damped(3)
	local sea = sea_mod.new(love.graphics.getHeight()/2)
	local sea_increment = 0

	local node_list = require('node_list')
	initial_nodes(node_list)
	cam:lookAt(0, 0)

	node_list.jumpCallback = function(node_list_arg)
		node_procedural.genNext(node_list_arg)
	end


	function self:draw()
		love.graphics.push()
		cam:attach()
		node_list:draw()
		cam:detach()
		sea:draw(300-cam.y-sea_increment)
		love.graphics.pop()
	end

	function self:trailed_x_offset() --calc x offset if the player is deciding the next path
		local connections = node_list:connections_from(node_list.active_node)
		local total = #connections
		local selected
		for i,connection in ipairs(connections) do
			if connection[3] then
				selected=i
			end
		end
		if total > 1 and selected  then
			return Lerp(-50, 50, (selected-1)/(total-1))
		else
			return 0
		end

	end

	function self:update(dt)
		node_list:update(dt)
		if ScreenManager.peek().name ~= "game" then return end
		sea:update(dt)
		local focused_node = node_list:get_focused_node()
		local x_offset = 0
		if node_list:completed() then
			x_offset = self:trailed_x_offset()
		end
		if focused_node then
			cam:lockPosition(focused_node.x + x_offset, focused_node.y, damped)
		end
		sea_increment = sea_increment + 10*dt
	end

	function self:keyreleased(key)
		node_list:keyreleased(key)
	end

	function self:keypressed(key)
		node_list:keypressed(key)
	end
	return self
end

return game
