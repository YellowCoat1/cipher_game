local loveDialogue = require("libs.LoveDialogue")
local Screen = require('screens.Screen')

local dialogue = {}

function dialogue.new()

	local self = Screen:new()

	local dialog_scene = loveDialogue.play("scripts/script.ld", DialogueConfig)

	dialog_scene.onSignal = function(name, args)
		if name == "EndDialogue" then
			ScreenManager.publish("dialogueEnd")
		end
	end

	function self:draw()
		if dialog_scene then dialog_scene:draw() end
	end
	function self:update(dt)
		if dialog_scene then dialog_scene:update(dt) end
	end
	function self:keypressed(key)
		if dialog_scene then dialog_scene:keypressed(key) end
	end



	return self
end


return dialogue

