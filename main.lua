ScreenManager = require("libs.ScreenManager")
PROF_CAPTURE = false
Profiler = require('libs.jprof')
local highscore = require 'highscore_fs'
local exit = require 'exit'

LynxNoteValid = true

DialogueConfig = {
	boxHeight = 200,
	boxWidth = 800,
	centerBox = true,
	boxColor = {0, 0, 0, 1},
	borderColor = {1, 1, 1, 1},
	borderWidth = 3
}

SurvivedTime = 0

FontName = "assets/hijo.regular.otf"

Settings = {}

function love.load()
	Profiler.connect(true)
	Settings.high_score = tonumber(highscore.get()) or Settings.high_score
	Settings.high_score_spikes = tonumber(highscore.get_spike()) or Settings.high_score_spikes

	DialogueConfig = {
		boxHeight = 200,
		boxWidth = math.max(love.graphics.getWidth()-300, 50),
		centerBox = true,
		boxColor = {0, 0, 0, 1},
		borderColor = {1, 1, 1, 1},
		borderWidth = 3
	}


	local screens = {
		main = require('screens.mainMenu'),
		scrollingBG = require('screens.scrollingBG'),
		manager = require('screens.gameManager'),
		game = require('screens.game'),
		tutorial = require('screens.tutorial'),
		transition_out = require('screens.transition_out'),
		transition_in = require('screens.transition_in'),
		death = require('screens.death'),
		lynx_note = require('screens.lynx_note'),
		settings = require('screens.settings')
	}

	ScreenManager.init(screens, 'manager')
	ScreenManager.push("scrollingBG")
	ScreenManager.push("main")
	love.graphics.setBackgroundColor(1, 1, 1, 1)
	exit.load()
end

function love.draw()
	DialogueConfig = {
		boxHeight = 200,
		boxWidth = math.max(love.graphics.getWidth()-300, 50),
		centerBox = true,
		boxColor = {0, 0, 0, 1},
		borderColor = {1, 1, 1, 1},
		borderWidth = 3
	}
	ScreenManager.draw()
	exit.draw()
	Profiler.pop("frame")
end

function love.keypressed(key)
	ScreenManager.keypressed(key)
end

function love.keyreleased(key)
	ScreenManager.keyreleased(key)
end
function love.mousepressed(x, y, button)
	ScreenManager.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	ScreenManager.mousereleased(x, y, button)
end
function love.update(dt)
	Profiler.push("frame")
	ScreenManager.update(dt)
	exit.update(dt)
	--print(ScreenManager.peek().name)
end
