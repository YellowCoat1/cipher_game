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
				LynxNoteValid = false
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
			if LynxNoteValid then
				ScreenManager.push('lynx_note')
			end
		elseif message == "restart" then
			ScreenManager.pop()
			ScreenManager.pop()
			ScreenManager.push("game")
		elseif message == "settings" then
			ScreenManager.push("settings")
		elseif message == "settings_exit" then
			ScreenManager.pop()
		elseif message == "exit_to_main" then
			ScreenManager.switch("manager")
			ScreenManager.push("scrollingBG")
			ScreenManager.push("main")
		end
	end
	return self
end


return gameManager

