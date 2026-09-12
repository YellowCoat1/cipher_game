package.path = "./?.lua" .. ';./' .. "libs" .. '/?.lua'

ScreenManager = require("libs.ScreenManager")

function love.load()

	local screens = {
		main = require('screens.mainMenu'),
		scrollingBG = require('screens.scrollingBG'),
		manager = require('screens.gameManager'),
		dialogue = require ('screens.dialogue'),
		game = require('screens.game'),
	}

	ScreenManager.registerCallbacks()
	ScreenManager.init(screens, 'manager')
	ScreenManager.push("scrollingBG")
	ScreenManager.push("main")
	love.graphics.setBackgroundColor(1, 1, 1, 1)
end

