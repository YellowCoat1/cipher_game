local Screen = require('screens.Screen')

local gameManager = {}

function gameManager.new()

	local self = Screen:new()

	local tutorial_done = false

	function self:receive(message)
		if message == "mainMenuStart" then
			ScreenManager.pop()
			if love.keyboard.isDown("p") then
				ScreenManager.push("game")
				ScreenManager.push("transition_in")
			else
				ScreenManager.push("tutorial")
			end
		elseif message == "tutorialEnd" then
			ScreenManager.push("transition_out")
		elseif message == "transition_done" then
			ScreenManager.pop()
			ScreenManager.pop()
			ScreenManager.push("game")
			ScreenManager.push("transition_in")
		elseif message == "transition_in_done" and not tutorial_done then
			tutorial_done = true
			ScreenManager.pop()
			ScreenManager.push("final_tutorial")
		elseif message == "final_tutorial_end" then
			ScreenManager.pop()
		elseif message == "died :(" then
			ScreenManager.push("death")
		elseif message == "restart" then
			ScreenManager.pop()
			ScreenManager.pop()
			ScreenManager.push("game")
		end
	end
	return self
end


return gameManager

