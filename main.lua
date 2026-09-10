package.path = "./?.lua" .. ';./' .. "libs" .. '/?.lua'

local LoveDialogue = require("libs.LoveDialogue")
local dialog

function love.load()
	dialog = LoveDialogue.play("script.ld", {
		boxHeight = 200,
		boxWidth = 800,
		centerBox = true,
		boxColor = {0, 0, 0, 1},
		borderColor = {1, 1, 1, 1},
		borderWidth = 3
	})

	dialog.onSignal = function(name, args)
		if name == "EndDialogue" then love.event.quit() end
	end
end

function love.update(dt)
	if dialog then dialog:update(dt) end
end

function love.draw()
	if dialog then dialog:draw() end
end


function love.keypressed(key)
	if dialog then dialog:keypressed(key) end
end
