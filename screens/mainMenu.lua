local Screen = require('screens.Screen')

local MainScreen = {}

local font = love.graphics.newFont(64, "normal")
local square_dimensions = {
	x = 100,
	y = 300,
	width = font:getWidth("Play")+80,
	height = 100
}
function MainScreen.new()
    local self = Screen.new()

    self.fadeOut = nil

    function self:draw()
	love.graphics.push()
	love.graphics.setColor(0, 0, 0)
        love.graphics.print("man i love main screens", 0, 0)

	local opacity = self.fadeOut or 1
	love.graphics.setColor(0.4, 0.4, 0.6, opacity)
	love.graphics.rectangle("fill", square_dimensions.x, square_dimensions.y, square_dimensions.width, square_dimensions.height)
	love.graphics.setColor(0.1, 0.1, 0.1, opacity)
	
	love.graphics.print("play", font, square_dimensions.x+40, square_dimensions.y)
	love.graphics.print("a dumbass cipher fanart game", font, 300, 100, 0.5, 0.5)
	love.graphics.pop()
    end

    function self:update(dt)
	    if self.fadeOut then
		    self.fadeOut = self.fadeOut - 1.5 * dt
	    end
    end
    

    function self:mousereleased(x, y)
	    if x > square_dimensions.x and x < square_dimensions.x + square_dimensions.width and
		    y > square_dimensions.y and y < square_dimensions.y + square_dimensions.height then
		    print("button pressed!")
		    self.fadeOut = 1
	    end

    end

    return self
end

return MainScreen
