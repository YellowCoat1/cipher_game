local ring_png = love.graphics.newImage("assets/ring_white.png")
local ring_width, ring_height = ring_png:getWidth(), ring_png:getHeight()
local arrow_png = love.graphics.newImage("assets/arrow.png")
local arrow_width, arrow_height = arrow_png:getWidth(), arrow_png:getHeight()

local coal_color = {64/256, 64/256, 64/256}
local cipher_main_color = {53/255, 74/255, 255/255}
local cipher_secondary_color = {107/255, 128/255, 255/255}

local directions = {
	UP = 1,
	DOWN = 2,
	LEFT = 3,
	RIGHT = 4,
}

function Lerp(start, endt, t)
	return start * (1-t) + endt * t
end

local function lerpColor(startc, endc, t)
	return {Lerp(startc[1], endc[1], t), Lerp(startc[2], endc[2], t), Lerp(startc[3], endc[3], t)}
end

local random = love.math.random

local function node(x, y, alen)
	local node = {}
	node.x = x or 100
	node.y = y or 100
	node.ring1_rotation = 0
	node.centerOffsetX = 0
	node.centerOffsetY = 0
	node.cooldown_timer = 0
	node.cooldown_multiplier = 1
	node.active = false
	node.completed_timer = 0

	local hit_sound = love.audio.newSource("assets/hit.wav", "static")
	local takeover_sound = love.audio.newSource('assets/takeover.wav', "static")
	local wrong_sound = love.audio.newSource('assets/wrong.wav', "static")


	node.pattern = {}
	alen = alen or 10
	for _=1, alen do
		table.insert(node.pattern, random(1, 4))
	end

	function node:draw(opacity)
		opacity = opacity or 1
		if not self:completed() then
			love.graphics.setColor(coal_color[1], coal_color[2], coal_color[3], opacity)
		else
			local lc = lerpColor(coal_color, cipher_main_color, self.completed_timer)
			love.graphics.setColor(lc[1], lc[2], lc[3], opacity)
		end
		love.graphics.circle("fill", self.x+self.centerOffsetX, self.y+self.centerOffsetY, 45)
		local ring_scale = 0.5
		if self:completed() then
			love.graphics.setColor(lerpColor(coal_color, cipher_secondary_color, self.completed_timer))
		end
		love.graphics.draw(ring_png, self.x, self.y, self.ring1_rotation, ring_scale, ring_scale, ring_width/2, ring_height/2)
		local arrow_direction = node.pattern[#node.pattern] or 1
		local arrow_rotation
		if arrow_direction == 1 then
			arrow_rotation = math.rad(360-90)
		elseif arrow_direction == 2 then
			arrow_rotation = math.rad(90)
		elseif arrow_direction == 3 then
			arrow_rotation = math.rad(180)
		else
			arrow_rotation = math.rad(0)
		end
		love.graphics.setColor(125/256, 230/256, 125/256, opacity)
		if self.cooldown_timer > 0 then
			love.graphics.setColor(1, 0, 0, opacity)
		end
		if not self:completed() then
			love.graphics.draw(arrow_png, self.x+self.centerOffsetX, self.y+self.centerOffsetY, arrow_rotation, 0.1, 0.1, arrow_width/2, arrow_height/2)
		end
	end

	function node:update(dt)
		local ring_speed
		if node.active then
			ring_speed = 5
		else
			ring_speed = 1
		end
		self.ring1_rotation = self.ring1_rotation + ring_speed*dt
		self.centerOffsetX = self.centerOffsetX * math.pow(0.5, dt / 0.1)
		self.centerOffsetY = self.centerOffsetY * math.pow(0.5, dt / 0.1)
		if self.cooldown_timer > 0 then
			self.cooldown_timer = self.cooldown_timer - dt
		end

		if self:completed() and self.completed_timer < 1 then
			self.completed_timer = self.completed_timer + 2 * dt
		end
		if self.completed_timer > 1 then
			self.completed_timer = 1
		end
	end

	function node:keyreleased(key)
		if self.cooldown_timer > 0 then
			return
		end
		if key == "left" or key == "a" then
			self:left()
		elseif key == "right" or key == "d" then
			self:right()
		elseif key == "up" or key == "w" then
			self:up()
		elseif key == "down" or key == "s" then
			self:down()
		end
	end

	local offset_amount = 10
	function node:left()
		if self.pattern[#self.pattern] == directions.LEFT then
			self.centerOffsetX = -offset_amount
			self.centerOffsetY = 0
			table.remove(self.pattern, #self.pattern)
			self:onSuccess()
		else
			self:cooldown()
		end
	end

	function node:right()
		if self.pattern[#self.pattern] == directions.RIGHT then
			self.centerOffsetX = offset_amount
			self.centerOffsetY = 0
			table.remove(self.pattern, #self.pattern)
			self:onSuccess()
		else
			self:cooldown()
		end
	end

	function node:up()
		if self.pattern[#self.pattern] == directions.UP then
			self.centerOffsetX = 0
			self.centerOffsetY = -offset_amount
			table.remove(self.pattern, #self.pattern)
			self:onSuccess()
		else
			self:cooldown()
		end
	end

	function node:down()
		if self.pattern[#self.pattern] == directions.DOWN then
			self.centerOffsetX = 0
			self.centerOffsetY = offset_amount
			table.remove(self.pattern, #self.pattern)
			self:onSuccess()
		else
			self:cooldown()
		end
	end

	function node:onSuccess()
		if not self:completed() then
			local pitch = (love.math.random()/5) + 4.5/5
			hit_sound:setPitch(pitch)
			hit_sound:play()
		else
			takeover_sound:play()
		end
	end

	function node:cooldown()
		if node:completed() then return end
		wrong_sound:play()
		self.cooldown_timer = 0.5 * self.cooldown_multiplier
		if self.cooldown_multiplier < 3 then
			self.cooldown_multiplier = self.cooldown_multiplier + 1
		end
	end

	function node:completed()
		return #self.pattern == 0
	end


	return node
end


return node
