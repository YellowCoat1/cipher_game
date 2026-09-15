local lynx_note = {}
local loveDialogue = require 'libs.LoveDialogue'
local screen = require 'screens.Screen'
function lynx_note.new()
	local self = screen.new()
	self.name = "lynx note"
	local timer = 0
	local dialog
	LynxNoteValid = false


	function self:draw()
		if dialog then dialog:draw() end
	end
	function self:update(dt)
		if dialog then dialog:update(dt) end
		timer = timer + dt
		if timer > 0.5 and not dialog then
			dialog = loveDialogue.play("scripts/final.ld", DialogueConfig)

			dialog.onSignal = function(name, _)
				if name == "LynxEnd" then
					ScreenManager.pop()
					return
				end
			end
		end

		if love.keyboard.isDown("p") then
			ScreenManager.pop()
		end
	end
	function self:keypressed(key)
		if dialog then dialog:keypressed(key) end
	end

	return self
end

return lynx_note
