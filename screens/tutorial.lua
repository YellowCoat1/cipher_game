local Screen = require('screens.Screen')
local loveDialogue = require('libs.LoveDialogue')
local node = require('node')

local tutorial = {}

local phases = {
	BEFORE_NODE = 1,
	BEFORE_SEA = 2,
	AFTER_SEA = 3,
}

function tutorial.new()
	local self = Screen:new()
	self.phase = phases.BEFORE_NODE
	self.dialog_scene = loveDialogue.play("scripts/tut1.ld", DialogueConfig)
	self.dialog_scene.onSignal = function(name, _)
		if name == "Tut1End" then
			self:tut1End()
		end
	end

	function self:draw()
		if self.dialog_scene then self.dialog_scene:draw() end
		if self.node then self.node:draw() end
	end
	function self:update(dt)
		if self.dialog_scene then self.dialog_scene:update(dt) end
		if self.node then
			self.node:update(dt)
			if self.node.completed_timer >= 1 then
				self.node = nil
				self:tut2Start()
			end
		end
	end
	function self:keypressed(key)
		if self.dialog_scene then self.dialog_scene:keypressed(key) end
	end
	function self:keyreleased(key)
		if self.node then self.node:keyreleased(key) end
	end

	function self:tut1End()
		self.node = node(love.graphics.getWidth()/2, love.graphics.getHeight()/2, 3)
		self.node.active = true
	end

	function self:tut2Start()
		self.dialog_scene = loveDialogue.play("scripts/tut2.ld", DialogueConfig)
	end


	return self
end

return tutorial
