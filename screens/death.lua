local Screen = require 'screens.Screen'
local death = {}

local cipher_main_color = {53/255, 74/255, 255/255}
local cipher_secondary_color = {107/255, 128/255, 255/255}

local font = love.graphics.newFont(64, "normal")
local smaller_font = love.graphics.newFont(40, "normal")

function death.new()
	local self = Screen:new()
	self.name = "death"
	local death_timer = 0
	local death_timer_max = 0.85
	local button_pressed = false

	local cipher_ded = love.graphics.newImage('assets/cipher_ded.png')
	local cipher_width, cipher_height = cipher_ded:getWidth(), cipher_ded:getHeight()
	local evil_glad = love.graphics.newImage('assets/evil_glad.png')
	local evil_width, evil_height = evil_glad:getWidth(), evil_glad:getHeight()

	function self:draw()
		local width, height = love.graphics.getDimensions()
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.setColor(0, 0, 0, death_timer)
		love.graphics.rectangle("fill", 0, 0, width, height)

		if death_timer == death_timer_max then
			-- top text
			love.graphics.setColor(cipher_main_color)
			love.graphics.print("Flooded!", font, (width/2)-font:getWidth("Flooded!")/2, height/5)
			love.graphics.setColor(cipher_secondary_color)
			love.graphics.print("Score: ABC", smaller_font, (width/2)-smaller_font:getWidth("Score: ABC")/2, height/5+height/10)
			-- middle button
			love.graphics.setColor(0, 0, 0, 0.3)
			if button_pressed then
				love.graphics.setColor(0, 0, 0, 0.6)
			end
			love.graphics.rectangle("fill", 0, height*(3/7), width, height*(1/7))
			love.graphics.setColor(0, 0, 0, 1)
			love.graphics.line(0, height*(3/7), width, height*(3/7))
			love.graphics.line(0, height*(4/7), width, height*(4/7))
			love.graphics.setColor(cipher_main_color)
			love.graphics.print("restart", font, (width/2) - (font:getWidth("restart")/2), (height*(3.5/7)) - font:getHeight()/2)

			--love.graphics.setColor(0, 0, 0, 1)
			--love.graphics.line(width/2, 0, width/2, height)

			-- cipher and evil
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.draw(cipher_ded, width*(2/7), height*(4/5), 5.3, 0.3, 0.3, cipher_width/2, cipher_height/2)
			love.graphics.draw(evil_glad, width*(5/7), height*(4/5), 0, 0.3, 0.3, evil_width/2, evil_height/2)

		end
	end

	function self:update(dt)
		death_timer = math.min(death_timer_max, death_timer + dt*(1))
	end


	function self:mousepressed(_, y, button)
		local height = love.graphics.getHeight()
		if button == 1 and y >= height*(3/7) and y <= height*(4/7) then
			button_pressed = true
		end
	end

	function self:mousereleased(_, y, button)
		local height = love.graphics.getHeight()
		if button == 1 and y >= height*(3/7) and y <= height*(4/7) then
			print("restart")
			button_pressed = false
		elseif button == 1 then
			button_pressed = false
		end
	end
	return self
end

return death
