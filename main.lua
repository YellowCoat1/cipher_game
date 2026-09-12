package.path = "./?.lua" .. ';./' .. "libs" .. '/?.lua'

ScreenManager = require("libs.ScreenManager")

local dialog

function love.load()

	local screens = {
		main = require('screens.mainMenu'),
		scrollingBG = require('screens.scrollingBG'),
		manager = require('screens.gameManager'),
		dialogue = require ('screens.dialogue')
	}

	ScreenManager.init(screens, 'manager')
	ScreenManager.push("scrollingBG")
	ScreenManager.push("main")
	love.graphics.setBackgroundColor(1, 1, 1, 1)
end

function love.update(dt)
	ScreenManager.update(dt)
	if dialog then dialog:update(dt) end
end

function love.draw()
	ScreenManager.draw()
end


function love.keypressed(key, scancode, isrepeat)
	ScreenManager.keypressed(key, scancode, isrepeat)
end

function love.mousereleased(x, y, button)
	ScreenManager.mousereleased(x, y, button)
end
