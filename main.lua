ScreenManager = require("libs.ScreenManager")

DialogueConfig = {
	boxHeight = 200,
	boxWidth = 800,
	centerBox = true,
	boxColor = {0, 0, 0, 1},
	borderColor = {1, 1, 1, 1},
	borderWidth = 3
}

SurvivedTime = 0

function love.load()

	local screens = {
		main = require('screens.mainMenu'),
		scrollingBG = require('screens.scrollingBG'),
		manager = require('screens.gameManager'),
		game = require('screens.game'),
		tutorial = require('screens.tutorial'),
		transition_out = require('screens.transition_out'),
		transition_in = require('screens.transition_in'),
		final_tutorial = require('screens.final_tutorial'),
		death = require('screens.death'),
	}

	ScreenManager.init(screens, 'manager')
	ScreenManager.push("scrollingBG")
	ScreenManager.push("main")
	love.graphics.setBackgroundColor(1, 1, 1, 1)
end

function love.draw()
	ScreenManager.draw()
end

function love.keypressed(key)
	ScreenManager.keypressed(key)
end

function love.keyreleased(key)
	ScreenManager.keyreleased(key)
end

function love.mousereleased(x, y, button)
	ScreenManager.mousereleased(x, y, button)
end
function love.update(dt)
	ScreenManager.update(dt)
end
