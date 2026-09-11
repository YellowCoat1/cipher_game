package.path = "./?.lua" .. ';./' .. "libs" .. '/?.lua'

local LoveDialogue = require("libs.LoveDialogue")
local ScreenManager = require("libs.ScreenManager")

local dialog

function love.load()

	local screens = {
		main = require('screens.mainMenu'),
		scrollingBG = require('screens.scrollingBG'),
	}

	ScreenManager.init(screens, 'scrollingBG')
	ScreenManager.push("main")

	--dialog = LoveDialogue.play("script.ld", {
	--	boxHeight = 200,
	--	boxWidth = 800,
	--	centerBox = true,
	--	boxColor = {0, 0, 0, 1},
	--	borderColor = {1, 1, 1, 1},
	--	borderWidth = 3
	--})

	--dialog.onSignal = function(name, args)
	--	if name == "EndDialogue" then love.event.quit() end
	--end

	love.graphics.setBackgroundColor(1, 1, 1, 1)
end

function love.update(dt)
	ScreenManager.update(dt)
	if dialog then dialog:update(dt) end
end

function love.draw()
	ScreenManager.draw()
	if dialog then dialog:draw() end
end


function love.keypressed(key)
	if dialog then dialog:keypressed(key) end
end

function love.mousereleased(x, y, button)
	ScreenManager.mousereleased(x, y, button)
end
