local Screen = require('screens.Screen')

local MainScreen = {}

local font = love.graphics.newFont(64, "normal")
local square_dimensions = {
	x = 100,
	y = 300,
	width = font:getWidth("Play")+80,
	height = 100
}
local lynx = love.graphics.newImage("assets/Lynx.png")
local lynx_width, lynx_height = lynx:getWidth(), lynx:getHeight()



function MainScreen.new()
    local self = Screen.new()
    self.name = "main menu"

    self.fadeOut = nil

    self.lynx_rotation = 0

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

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(lynx, love.graphics.getWidth()-100, love.graphics.getHeight()-100, self.lynx_rotation, 0.5, 0.5, lynx_width/2, lynx_height/2)
	love.graphics.pop()
    end

    function self:update(dt)
	    if self.fadeOut then
		    self.fadeOut = self.fadeOut - 1.5 * dt
		    if self.fadeOut <= 0 and self.fadeOut > -90 then
			    ScreenManager.publish("mainMenuStart")
			    self.fadeOut = -100
		    end
	    end
	    self.lynx_rotation = self.lynx_rotation + 5*dt
    end
    

    function self:mousereleased(x, y)
	    if x > square_dimensions.x and x < square_dimensions.x + square_dimensions.width and
		    y > square_dimensions.y and y < square_dimensions.y + square_dimensions.height then
		if not self.fadeOut then
		    self.fadeOut = 1
		end
	    end

    end

    return self
end

return MainScreen
