local Screen = require('screens.Screen')
local node = require('node')
local camera = require 'libs.camera'
local sea_mod = require('sea')
local node_procedural = require 'node_proceduaral'

local function initial_nodes(node_list)
	local node1 = node(0, 0, 2)
	local node2 = node(-200, -300, 2)
	local node3 = node(200, -300, 2)
	local node4 = node(-200, -600, 2)
	local node5 = node(200, -600, 2)
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
	local dead = false
	local game_active_timer = 0
	local font = love.graphics.newFont(FontName, 32)
	if not GameMusic then
		GameMusic = love.audio.newSource("assets/Serge Quadrado - Technocrat.mp3", "stream")
		GameMusic:play()
	end

	local node_list = require('node_list').new()
	initial_nodes(node_list)
	cam:lookAt(0, 0)


	local function node_pattern_len(node_list_t)
		if not node_list_t.active_node then return 3 end

		local active_y = -node_list_t.nodes[node_list.active_node].y


		return 2+math.floor(active_y/1500)
	end

	local function node_spike(node_list_t)
		if not node_list_t.active_node then return false end
		local active_y = -node_list_t.nodes[node_list.active_node].y

		local cap = 0.90
		if active_y > 900 then
			cap = cap - 0.1
		end
		if active_y > 2100 then
			cap = cap - 0.05
		end
		if active_y > 3600 then
			cap = cap - 0.1
		end
		return love.math.random() > cap
	end

	node_procedural.spike_callback = node_spike
	node_procedural.pattern_len_callback = node_pattern_len

	node_list.jumpCallback = function(node_list_arg)
		node_procedural.genNext(node_list_arg)
		node_procedural.cleanup(node_list_arg)
	end


	function self:draw()
		love.graphics.push()
		cam:attach()
		node_list:draw()
		cam:detach()
		sea:draw(300-cam.y-sea_increment)
		local width = love.graphics.getWidth()

		local box_width, box_height = 130, 40
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.rectangle("fill", width-box_width, 0, box_width, box_height)
		love.graphics.setColor(0, 0, 0, 1)
		local timer_string = tostring(math.floor(game_active_timer*1000)/1000)
		if timer_string == "0" then
			timer_string = "0.000"
		end
		love.graphics.print(timer_string, font, width-box_width+5, 10)
		love.graphics.setColor(0, 0, 1, 1)
		love.graphics.line(width-box_width, 0, width-box_width, box_height)
		love.graphics.line(width-box_width, box_height, width, box_height)

		love.graphics.pop()
	end

	function self:trailed_x_offset() --calc x offset if the player is deciding the next path
		local connections, selected = node_list:selected_edge()
		local total = #connections
		if total > 1 and selected  then
			return Lerp(-50, 50, (selected-1)/(total-1))
		else
			return 0
		end

	end

	function self:update(dt)
		node_list:update(dt)
		if ScreenManager.peek().name ~= "game" then return end
		if dead then return end
		sea:update(dt)
		game_active_timer = game_active_timer + dt
		local focused_node = node_list:get_focused_node()
		local x_offset = 0
		if node_list:completed() then
			x_offset = self:trailed_x_offset()
		end
		if focused_node then
			cam:lockPosition(focused_node.x + x_offset, focused_node.y, damped)
		end

		if not focused_node then return end

		local sea_increment_change
		if game_active_timer < 10 then
			-- for the first 10 seconds, speed increases by 8 per second
			sea_increment_change = 8*game_active_timer*dt
		elseif game_active_timer < 30 then
			-- then up to 30, it increases by 2 per second
			sea_increment_change = (7*10*dt) + (2*(game_active_timer-15)*dt)
		else
			-- for the rest of the game, it increases by 1 per second
			sea_increment_change = (7*10*dt) + (3*15*dt) + (1*(game_active_timer-30)*dt)
		end

		sea_increment_change = sea_increment_change + 40*dt -- constant factor

		sea_increment = sea_increment + sea_increment_change

		if -focused_node.y > sea_increment + 400 then -- boost
			sea_increment = sea_increment + sea_increment_change*(0.8) + 50*dt
		end

		if sea_increment  > -focused_node.y + 300 and not dead then
			self:die()
		end

	end

	function self:die()
		dead = true
		SurvivedTime = game_active_timer
		ScreenManager.publish('died :(')
	end

	function self:keyreleased(key)
		if key == "k" then
			self:die()
		end
		node_list:keyreleased(key)
	end

	function self:keypressed(key)
		node_list:keypressed(key)
	end
	return self
end

return game
