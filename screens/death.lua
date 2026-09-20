local Screen = require 'screens.Screen'
local colors = require 'colors'
local death = {}

local cipher_main_color = colors.cipher_main_color
local cipher_secondary_color = colors.cipher_secondary_color

local font = love.graphics.newFont(FontName, 64)
local smaller_font = love.graphics.newFont(FontName, 40)

local highscore = require 'highscore_fs'

local function round_hundreth(n)
	return math.floor(n*1000)/1000
end

function death.new()
	local self = Screen:new()
	self.name = "death"
	local death_timer = 0
	local death_timer_max = 0.85
	local button_pressed = false

	local time = 0
	local cipher_ded = love.graphics.newImage('assets/cipher_ded.png')
	local cipher_width, cipher_height = cipher_ded:getWidth(), cipher_ded:getHeight()
	local evil_glad = love.graphics.newImage('assets/evil_glad.png')
	local evil_width, evil_height = evil_glad:getWidth(), evil_glad:getHeight()

	local death_sfx = love.audio.newSource('assets/die.wav', "static")
	local restart_sfx = love.audio.newSource('assets/restart.wav', "static")
	death_sfx:play()

	love.mouse.setVisible(true)


	GameMusic:setFilter({
		type = "lowpass",
		volume = .5,
		highgain = 0.3,
	})


	local high_score = false


	if not Settings.spikeys then
		if not Settings.high_score then
			Settings.high_score = SurvivedTime
			highscore.set(SurvivedTime)
			high_score = true
		elseif Settings.high_score <= SurvivedTime then
			Settings.high_score = SurvivedTime
			highscore.set(SurvivedTime)
			high_score = true
		else
			high_score = false
		end
	else
		if not Settings.high_score_spikes then
			Settings.high_score_spikes = SurvivedTime
			highscore.set_spike(SurvivedTime)
			high_score = true
		elseif Settings.high_score_spikes <= SurvivedTime then
			Settings.high_score_spikes = SurvivedTime
			highscore.set_spike(SurvivedTime)
			high_score = true
		else
			high_score = false
		end
	end

	function self:draw()
		local width, height = love.graphics.getDimensions()
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.setColor(0, 0, 0, death_timer)
		love.graphics.rectangle("fill", 0, 0, width, height)

		if death_timer == death_timer_max then
			-- top text
			love.graphics.setColor(cipher_main_color)
			love.graphics.print("Flooded!", font, (width/2) - (font:getWidth("Flooded!")/2), height/5)
			love.graphics.setColor(cipher_secondary_color)
			SurvivedTime = round_hundreth(SurvivedTime or 0)
			love.graphics.print("Score: "..SurvivedTime, smaller_font, (width/2)-smaller_font:getWidth("Score: "..SurvivedTime)/2, height/5+height/10)
			local hs_text
			if Settings.spikeys then
				hs_text = Settings.high_score_spikes
			else
				hs_text = Settings.high_score
			end
			love.graphics.print("Highscore: "..round_hundreth(hs_text), smaller_font, (width/2)-smaller_font:getWidth("Highscore: "..round_hundreth(Settings.high_score))/2, height/5+height/10 + smaller_font:getHeight() + 10)
			-- high score
			if high_score then
				love.graphics.print("High Score!", smaller_font, width*(9/11), height*(1/5), math.sin(time*5)*0.4, 1+math.cos(time*5)*(1/4), _, smaller_font:getWidth("High Score!")/2, smaller_font:getHeight()/2)
			end
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
			love.graphics.print("restart", font, (width/2) - (font:getWidth("restart")/2), 10+(height*(3.5/7)) - font:getHeight()/2)

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
		time = time + dt
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
			ScreenManager.publish("restart")
			love.mouse.setVisible(false)
			restart_sfx:play()
			button_pressed = false
		elseif button == 1 then
			button_pressed = false
		end
	end

	function self:keyreleased(key)
		if key == "p" then
			death_timer = death_timer_max
		end
	end

	function self:close()
		GameMusic:setFilter()
	end

	return self
end

return death
