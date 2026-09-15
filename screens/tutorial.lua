local Screen = require('screens.Screen')
local loveDialogue = require('libs.LoveDialogue')
local node = require('node')
local sea_mod = require("sea")
local colors = require("colors")

local tutorial = {}

local coal_color = colors.coal_color

local phases = {
	BEFORE_NODE = 1,
	DURING_NODE = 2,
	BEFORE_SEA = 3,
	DURING_SEA = 4,
	AFTER_SEA = 5,
	BRANCHES = 6,
}

local function smoothLerp(start, endt, t)
  t = 1 - math.pow(1 - t, 3)
  return Lerp(start, endt, t)
end


function tutorial.new()
	local self = Screen:new()
	self.phase = phases.BEFORE_NODE
	self.dialog_scene = loveDialogue.play("scripts/tut1.ld", DialogueConfig)
	self.dialog_scene.onSignal = function(name, _)
		if name == "Tut1End" then
			self:tut1End()
		end
	end
	local sea = sea_mod.new()
	local rising_sea_timer
	local node_list = require('node_list').new()
	local branches_tip_timer
	sea.ylevel = love.graphics.getHeight() + 50
	self.rising_sea_timer = nil
	self.node_completed = false

	local font = love.graphics.newFont(FontName, 16)

	local opacity_mod = require('opacity').new()
	local new_set_opacity_timer

	function self:draw()
		if self.dialog_scene then self.dialog_scene:draw() end
		if node_list.nodes[1] then
			node_list.nodes[1]:draw()
		end
		if new_set_opacity_timer and new_set_opacity_timer < 1 then
			opacity_mod.set_opacity = new_set_opacity_timer
			opacity_mod:attach()
		end
		node_list:draw()
		if new_set_opacity_timer and new_set_opacity_timer < 1 then
			opacity_mod:detach()
		end
		sea:draw()

		if self.phase == phases.BRANCHES then
			self:branches_tip_draw()
		end
	end

	function self:branches_tip_draw()
		if not branches_tip_timer then return end
		local offset = -60+60*math.sqrt(math.sqrt(branches_tip_timer))
		local width, height = love.graphics.getDimensions()
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.rectangle("fill", width*(3/5), offset, 200, 60)
		love.graphics.setColor(coal_color)
		love.graphics.line(width*(3/5), offset, width*(3/5), offset+60)
		love.graphics.line(width*(3/5), offset+60, width*(3/5)+200,offset+60)
		love.graphics.line(width*(3/5)+200, offset+60, width*(3/5)+200, offset)
		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.print("space -> jump", font, width*(3/5)+10, 10+offset)
		love.graphics.print("arrows -> select", font, width*(3/5)+10, 10+offset+30)
	end

	function self:update(dt)
		sea:update(dt)
		if self.dialog_scene then self.dialog_scene:update(dt) end

		if new_set_opacity_timer then
			new_set_opacity_timer = math.min(1, new_set_opacity_timer + 2*dt)
		end

		node_list:update(dt)
		if node_list.nodes[1] and node_list:completed() and self.node_completed == false then
			self:tut2Start()
			self.node_completed = true
		end

		if node_list:completed() then
			if node_list.active_node > 1 and not self.node_completed_2 then
				ScreenManager.publish("tutorial_end")
				self.node_completed_2 = true
			end
		end

		if rising_sea_timer then
			rising_sea_timer = rising_sea_timer + (1/5)*dt

			local min_timer = rising_sea_timer
			if rising_sea_timer > 1 then
				min_timer = 1
			end
			sea.ylevel = smoothLerp(love.graphics.getHeight()+10, love.graphics.getHeight()-200, min_timer)

			if rising_sea_timer > 1 and rising_sea_timer < 100 then
				self:tut3Start()
				rising_sea_timer = 101
			end
		else
			sea.ylevel = love.graphics.getHeight() + 50
		end

		if branches_tip_timer then
			branches_tip_timer = math.min(1, branches_tip_timer + dt)
		end

	end
	function self:keypressed(key)
		if self.dialog_scene then self.dialog_scene:keypressed(key) end
		node_list:keypressed(key)
	end

	function self:keyreleased(key)
		if key == "p" then
			self:skip()
			return
		end
		node_list:keyreleased(key)
	end

	function self:skip()
		LynxNoteValid = false
		if self.phase == phases.BEFORE_NODE then
			self.dialog_scene = nil
			self:tut1End()
		elseif self.phase == phases.DURING_NODE then
			node_list.nodes[1].pattern = {}
		elseif self.phase == phases.BEFORE_SEA then
			self.dialog_scene = nil
			self:begin_sea_rising()
		elseif self.phase == phases.DURING_SEA then
			rising_sea_timer = 1
		elseif self.phase == phases.AFTER_SEA then
			self.dialog_scene = nil
			self:new_branches()
		elseif self.phase == phases.BRANCHES then
			node_list.active_node = 2
			node_list.nodes[2].pattern = {}
		end
	end

	function self:tut1End()
		self.phase = phases.DURING_NODE
		local new_node = node(love.graphics.getWidth()/2, love.graphics.getHeight()/2, 3)
		node_list:insert_node(new_node)
		node_list:focused_node(1)
	end

	function self:tut2Start()
		self.dialog_scene = loveDialogue.play("scripts/tut2.ld", DialogueConfig)
		self.phase = phases.BEFORE_SEA
		self.dialog_scene.onSignal = function(name, _)
			if name == "Tut2End" then
				self:begin_sea_rising()
			end
		end
	end

	function self:begin_sea_rising()
		self.phase = phases.DURING_SEA
		rising_sea_timer = 0
		sea.ylevel = love.graphics.getHeight() + 10
		self.rising_sea_timer = 0
	end

	function self:tut3Start()
		self.phase = phases.AFTER_SEA
		self.dialog_scene = loveDialogue.play("scripts/tut3.ld", DialogueConfig)

		self.dialog_scene.onSignal = function(name, _)
			if name == "Tut3End" then
				self:new_branches()
			end
		end
	end

	function self:new_branches()
		self.phase = phases.BRANCHES
		branches_tip_timer = 0
		local new_node_2 = node(200+love.graphics.getWidth()/2, love.graphics.getHeight()*(1/3), 3)
		local new_node_3 = node(-200+love.graphics.getWidth()/2, love.graphics.getHeight()*(1/3), 3)
		node_list:insert_nodes(new_node_2, new_node_3)
		node_list:insert_connection(1, 2)
		node_list:insert_connection(1, 3)
		new_set_opacity_timer = 0
	end


	return self
end

return tutorial
