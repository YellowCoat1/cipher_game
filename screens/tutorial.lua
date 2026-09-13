local Screen = require('screens.Screen')
local loveDialogue = require('libs.LoveDialogue')
local node = require('node')

local tutorial = {}

local phases = {
	BEFORE_NODE = 1,
	BEFORE_SEA = 2,
	AFTER_SEA = 3,
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
	local sea = require("sea")
	sea.ylevel = love.graphics.getHeight() + 50
	self.rising_sea_timer = nil

	function self:draw()
		if self.dialog_scene then self.dialog_scene:draw() end
		if self.node then self.node:draw() end
		sea:draw()
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
		sea:update(dt)
		if self.rising_sea_timer then
			self.rising_sea_timer = self.rising_sea_timer + (1/5)*dt
			local min_timer = math.min(self.rising_sea_timer, 1)
			sea.ylevel = smoothLerp(love.graphics.getHeight()+10, love.graphics.getHeight()-200, min_timer)

			--if self.rising_sea_timer > 1 and self.rising_sea_timer < 100 then
			--	self:tut3Start()
			--end
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
		local tut = self
		self.dialog_scene.onSignal = function(name, _)
			if name == "Tut2End" then
				tut.rising_sea_timer = 0
				sea.ylevel = love.graphics.getHeight() + 10
				self.rising_sea_timer = 0
			end
		end
	end

	--function self:tut3Start()
	--	self.dialog_scene = loveDialogue.play("scripts/tut3.ld", DialogueConfig)
	--end


	return self
end

return tutorial
