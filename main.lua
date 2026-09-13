ScreenManager = require("libs.ScreenManager")

DialogueConfig = {
	boxHeight = 200,
	boxWidth = 800,
	centerBox = true,
	boxColor = {0, 0, 0, 1},
	borderColor = {1, 1, 1, 1},
	borderWidth = 3
}

function love.load()

	local screens = {
		main = require('screens.mainMenu'),
		scrollingBG = require('screens.scrollingBG'),
		manager = require('screens.gameManager'),
		game = require('screens.game'),
		tutorial = require('screens.tutorial'),
	}

	ScreenManager.registerCallbacks()
	ScreenManager.init(screens, 'manager')
	ScreenManager.push("scrollingBG")
	ScreenManager.push("main")
	love.graphics.setBackgroundColor(1, 1, 1, 1)
end

