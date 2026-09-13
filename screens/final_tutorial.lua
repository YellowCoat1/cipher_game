local Screen = require('screens.Screen')
local loveDialogue = require('libs.LoveDialogue')

local final_tutorial = {}

function final_tutorial.new()
	local self = Screen:new()
	local dialog = loveDialogue.play("scripts/final.ld", DialogueConfig)
	self.name = "final"


	dialog.onSignal = function(name, _)
		if name == "TutFEnd" then
			ScreenManager.publish("final_tutorial_end")
		end
	end

	function self:draw()
		if dialog then dialog:draw() end
	end
	function self:update(dt)
		if dialog then dialog:update(dt) end
	end
	function self:keypressed(key)
		if dialog then dialog:keypressed(key) end
	end


	return self
end

return final_tutorial
