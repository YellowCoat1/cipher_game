local Screen = require('screens.Screen')

local gameManager = {}

function gameManager.new()

	local self = Screen:new()

	function self:receive(message)
		if message == "mainMenuStart" then
			ScreenManager.pop()
			ScreenManager.push("tutorial")
		elseif message == "tutoralEnd" then

		end
	end
	return self
end


return gameManager

