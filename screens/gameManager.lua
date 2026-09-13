local Screen = require('screens.Screen')

local gameManager = {}

function gameManager.new()

	local self = Screen:new()

	function self:receive(message)
		if message == "mainMenuStart" then
			ScreenManager.pop()
			ScreenManager.push("game")
			ScreenManager.push("transition_in")
		elseif message == "tutorialEnd" then
			ScreenManager.push("transition_out")
		elseif message == "transition_done" then
			ScreenManager.pop()
			ScreenManager.pop()
			ScreenManager.push("game")
			ScreenManager.push("transition_in")
		elseif message == "transition_in_done" then
			ScreenManager.pop()
			ScreenManager.push("final_tutorial")
		elseif message == "final_tutorial_end" then
			ScreenManager.pop()
		end
	end
	return self
end


return gameManager

