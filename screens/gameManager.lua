local Screen = require('screens.Screen')

local gameManager = {}

function gameManager.new()

	local self = Screen:new()

	function self:receive(message)
		if message == "mainMenuStart" then
			ScreenManager.pop()
			if love.keyboard.isDown("p") then
				ScreenManager.push("game")
				ScreenManager.push("transition_in")
			else
				ScreenManager.push("tutorial")
			end
		elseif message == "tutorial_end" then
			ScreenManager.push("transition_out")
		elseif message == "transition_done" then
			ScreenManager.pop()
			ScreenManager.pop()
			ScreenManager.push("game")
			ScreenManager.push("transition_in")
		elseif message == "transition_in_done" then
			ScreenManager.pop()
		elseif message == "died :(" then
			ScreenManager.push("death")
			ScreenManager.push('lynx_note')
		elseif message == "restart" then
			ScreenManager.pop()
			ScreenManager.pop()
			ScreenManager.push("game")
		end
	end
	return self
end


return gameManager

