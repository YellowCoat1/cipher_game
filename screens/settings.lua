local screen = require 'screens.Screen'
local colors = require 'colors'
local button = require 'button'
local slider = require 'slider'
local highscore_fs = require 'highscore_fs'

local coal_color = colors.coal_color
local cipher_secondary_color = colors.cipher_secondary_color
local settings = {}

local line = love.graphics.line

local font = love.graphics.newFont(FontName, 24)

local button_press_audio
local reset_audio
function settings.new()
	local self = screen:new()
	local exit_button = button.new(1, 1, 1, 1)
	local volume_slider =  slider.new(1, 1, 1, 1, (Settings.main_volume or 4/3)*3/4)
	local music_slider =  slider.new(1, 1, 1, 1, (Settings.music_volume or 4/3)*3/4)
	local sfx_slider =  slider.new(1, 1, 1, 1, (Settings.sfx_volume or 4/3)*3/4)
	local spikes_toggle = button.new(1, 1, 1, 1)
	local skip_tutorial = button.new(1, 1, 1, 1)
	local reset_score = button.new(1, 1, 1, 1)
	local fullscreen = button.new(1, 1, 1, 1)
	spikes_toggle.active = Settings.spikeys

	button_press_audio = love.audio.newSource('assets/button_click.mp3', "static")
	reset_audio = love.audio.newSource('assets/reset.wav', "static")
	self.name = "settings"


	function self:exit_button_calc()
		local width, height = love.graphics.getDimensions()
		exit_button.x = width*(4/5) - 80
		exit_button.y = height*(4/5) - 80
		exit_button.width = 50
		exit_button.height = 50
	end
	function self:spike_button_calc()
		spikes_toggle.x = sfx_slider.x
		spikes_toggle.y = sfx_slider.y + 80
		spikes_toggle.width = 40
		spikes_toggle.height = 40
	end
	function self:skip_tutorial_calc()
		skip_tutorial.x = sfx_slider.x
		skip_tutorial.y = spikes_toggle.y + 80
		skip_tutorial.width = 40
		skip_tutorial.height = 40
	end
	function self:reset_score_calc()
		reset_score.x = sfx_slider.x
		reset_score.y = skip_tutorial.y + 80
		reset_score.width = 250
		reset_score.height = 40
	end
	function self:fullscreen_calc()
		fullscreen.x = love.graphics.getWidth()/2
		fullscreen.y = spikes_toggle.y
		fullscreen.width = 40
		fullscreen.height = 40
	end
	function self:sliders_calc()
		local width, height = love.graphics.getDimensions()
		volume_slider.x = width*(1/5) + 50
		volume_slider.y = height*(1/5) + 50
		volume_slider.width = 300
		volume_slider.height = 40
		music_slider.x = volume_slider.x
		music_slider.y = volume_slider.y + 80
		music_slider.width = volume_slider.width
		music_slider.height = volume_slider.height
		sfx_slider.x = music_slider.x
		sfx_slider.y = music_slider.y + 80
		sfx_slider.width = music_slider.width
		sfx_slider.height = music_slider.height
	end

	function exit_button.draw()
		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.rectangle("line", exit_button.x, exit_button.y, exit_button.width, exit_button.height)
		line(exit_button.x + 10, exit_button.y + 10, exit_button.x+exit_button.width - 10, exit_button.y+exit_button.width - 10)
		line(exit_button.x + exit_button.width - 10, exit_button.y+10, exit_button.x + 10, exit_button.y + exit_button.height - 10)
		if exit_button.pressed then
			love.graphics.setColor(0, 0, 0, 0.4)
			love.graphics.rectangle("fill", exit_button.x, exit_button.y, exit_button.width, exit_button.height)
		end
	end

	function spikes_toggle.draw()
		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.rectangle("line", spikes_toggle.x, spikes_toggle.y, spikes_toggle.width, spikes_toggle.height)
		if spikes_toggle.active then
			love.graphics.setColor(0, 0, 0, 0.4)
			love.graphics.rectangle("fill", spikes_toggle.x, spikes_toggle.y, spikes_toggle.width, spikes_toggle.height)
		end
	end

	function skip_tutorial.draw()
		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.rectangle("line", skip_tutorial.x, skip_tutorial.y, skip_tutorial.width, skip_tutorial.height)
		if Settings.skip_tutorial then
			love.graphics.setColor(0, 0, 0, 0.4)
			love.graphics.rectangle("fill", skip_tutorial.x, skip_tutorial.y, skip_tutorial.width, skip_tutorial.height)
		end
	end

	function fullscreen.draw()
		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.rectangle("line", fullscreen.x, fullscreen.y, fullscreen.width, fullscreen.height)
		local fullscreened = love.window.getFullscreen()
		if fullscreened then
			love.graphics.setColor(0, 0, 0, 0.4)
			love.graphics.rectangle("fill", fullscreen.x, fullscreen.y, fullscreen.width, fullscreen.height)
		end
	end


	function reset_score.draw()
		love.graphics.setColor(0, 0, 0, 1)
		local line_width = 5
		love.graphics.setLineWidth(line_width)
		love.graphics.rectangle("line", reset_score.x, reset_score.y, reset_score.width, reset_score.height)
		local filledp = reset_score.timer or 0
		love.graphics.setColor(colors.with_opacity(cipher_secondary_color, 0.4))
		love.graphics.rectangle("fill", reset_score.x+line_width/2, reset_score.y+line_width/2, filledp*(reset_score.width-line_width), reset_score.height-line_width)
		love.graphics.setColor(0, 0, 0, 1)
		local text_width = font:getWidth("Reset Score")
		love.graphics.print("Reset Score", font, reset_score.x+(reset_score.width/2)-(text_width/2), reset_score.y+10)

		if (reset_score.feedback_timer or 0) > 0 then
			love.graphics.setColor(cipher_secondary_color)
			love.graphics.print("Reset!", font, reset_score.x+reset_score.width+50, reset_score.y+10)
		end
	end

	function reset_score.update(dt)
		button_press_audio:setVolume((Settings.main_volume or 1) * (Settings.sfx_volume or 1))
		reset_audio:setVolume((Settings.main_volume or 1) * (Settings.sfx_volume or 1))
		if reset_score.pressed then
			reset_score.timer = math.min((reset_score.timer or 0) + 0.4*dt, 1)
		else
			reset_score.timer = 0
		end

		if reset_score.timer == 1 then
			reset_score.pressed = false
			reset_score.timer = 0
			reset_score.feedback_timer = 2
			if reset_score.trigger2 then
				reset_score.trigger2()
			end
		end

		if reset_score.feedback_timer then
			reset_score.feedback_timer = math.max(0, reset_score.feedback_timer - dt)
		end

	end


	function exit_button.trigger()
		ScreenManager.publish("settings_exit")
		button_press_audio:play()
	end
	function spikes_toggle.trigger()
		spikes_toggle.active = not spikes_toggle.active
		button_press_audio:play()
	end
	function skip_tutorial.trigger()
		Settings.skip_tutorial = not Settings.skip_tutorial
		button_press_audio:play()
	end
	function reset_score.trigger2()
		reset_audio:play()
		highscore_fs.set(0)
		Settings.high_score = 0
		highscore_fs.set_spike(0)
		Settings.high_score_spikes = 0
	end
	function fullscreen.trigger()
		local fullscreened = love.window.getFullscreen()
		love.window.setFullscreen(not fullscreened)
		button_press_audio:play()
	end

	self:exit_button_calc()
	self:sliders_calc()
	self:spike_button_calc()
	self:skip_tutorial_calc()
	self:reset_score_calc()
	self:fullscreen_calc()
	love.graphics.setColor(0, 0, 0, 1)

	function self:draw()
		love.graphics.setColor(colors.with_opacity(coal_color, 0.95))
		local width, height = love.graphics.getDimensions()
		love.graphics.rectangle("fill", width*(1/5), height*(1/5), width*(3/5), height*(3/5))
		love.graphics.setColor(0, 0, 0, 1)
		local line_width = 5
		love.graphics.setLineWidth(line_width)
		line(width*(1/5), height*(1/5), width*(4/5)+line_width/2, height*(1/5))
		line(width*(4/5), height*(1/5), width*(4/5), height*(4/5)+line_width/2)
		line(width*(1/5), height*(4/5), width*(4/5)+line_width/2, height*(4/5))
		line(width*(1/5), height*(1/5)-line_width/2, width*(1/5), height*(4/5)+line_width/2)
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.setLineWidth(1)
		--love.graphics.print("settings", love.graphics.getWidth()/2, love.graphics.getHeight()/2)
		exit_button:draw()
		volume_slider:draw()
		music_slider:draw()
		sfx_slider:draw()
		spikes_toggle.draw()
		skip_tutorial.draw()
		fullscreen:draw()
		reset_score:draw()
		local y_offset = (volume_slider.height-font:getHeight())*(1/2)
		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.print("Main Volume", font, volume_slider.x + volume_slider.width + 20, volume_slider.y+y_offset)
		love.graphics.print("Music Volume", font, music_slider.x + music_slider.width + 20, music_slider.y+y_offset)
		love.graphics.print("SFX Volume", font, sfx_slider.x + sfx_slider.width + 20, sfx_slider.y+y_offset)
		love.graphics.print("Spike Hell", font, spikes_toggle.x + spikes_toggle.width + 20, spikes_toggle.y+y_offset)
		love.graphics.print("Skip Tutorial", font, skip_tutorial.x + skip_tutorial.width + 20, skip_tutorial.y+y_offset)
		love.graphics.print("Fullscreen", font, fullscreen.x + fullscreen.width + 20, fullscreen.y+y_offset)
	end

	function self:update(dt)
		volume_slider:update()
		music_slider:update()
		sfx_slider:update()

		self:exit_button_calc()
		self:sliders_calc()
		self:spike_button_calc()
		self:skip_tutorial_calc()
		self:reset_score_calc()
		self:fullscreen_calc()

		reset_score.update(dt)

		self:update_settings()
	end

	function self:update_settings()
		Settings.spikeys = spikes_toggle.active
		Settings.main_volume = volume_slider.slider_percent*(4/3)
		Settings.music_volume = music_slider.slider_percent*(4/3)
		Settings.sfx_volume = sfx_slider.slider_percent*(4/3)
	end

	function self:mousepressed(x, y, m)
		exit_button:mousepressed(x, y, m)
		spikes_toggle:mousepressed(x, y, m)
		skip_tutorial:mousepressed(x, y, m)
		volume_slider:mousepressed(x, y, m)
		music_slider:mousepressed(x, y, m)
		sfx_slider:mousepressed(x, y, m)
		reset_score:mousepressed(x, y, m)
		fullscreen:mousepressed(x, y, m)
	end

	function self:mousereleased(x, y, m)
		exit_button:mousereleased(x, y, m)
		spikes_toggle:mousereleased(x, y, m)
		skip_tutorial:mousereleased(x, y, m)
		volume_slider:mousereleased(x, y, m)
		music_slider:mousereleased(x, y, m)
		sfx_slider:mousereleased(x, y, m)
		reset_score:mousereleased(x, y, m)
		fullscreen:mousereleased(x, y, m)
	end

	return self
end

return settings
