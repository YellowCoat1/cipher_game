local Screen = require('screens.Screen')

local MainScreen = {}

function MainScreen.new()
    local self = Screen.new()
    self.name = "main menu"
    self.fadeOut = nil
    self.lynx_rotation = 0
    local bg_music = love.audio.newSource("assets/roman_sol-bg_music.wav", "stream")
    bg_music:setLooping(true)
    bg_music:play()

    local font = love.graphics.newFont(FontName, 64)
    local font_tiny = love.graphics.newFont(FontName, 10)
    local lynx = love.graphics.newImage("assets/Lynx.png")
    local lynx_width, lynx_height = lynx:getWidth(), lynx:getHeight()


    function self:draw()
    	local width, height = love.graphics.getDimensions()
	local square_dimensions = {
    		x = 1*width/5,
   	 	y = 2*height/5,
   	 	width = 400,
   	 	height = 100
   	 }
	love.graphics.push()
	love.graphics.setColor(0, 0, 0)
        love.graphics.print("man i love main screens", font_tiny, 20, 5)

	local opacity = self.fadeOut or 1
	love.graphics.setColor(0.4, 0.4, 0.6, opacity)
	love.graphics.rectangle("fill", square_dimensions.x, square_dimensions.y, square_dimensions.width, square_dimensions.height)
	love.graphics.rectangle("fill", square_dimensions.x, square_dimensions.y+150, square_dimensions.width, square_dimensions.height)
	love.graphics.setColor(0.1, 0.1, 0.1, opacity)

	love.graphics.print("play", font, square_dimensions.x+40, 20+square_dimensions.y)
	love.graphics.print("settings", font, square_dimensions.x+40, 20+square_dimensions.y+150)
	love.graphics.print("a dumbass cipher fanart game", font, width-600, height*(1/5), 0.5, 0.5)

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

    function self:close()
	bg_music:stop()
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
