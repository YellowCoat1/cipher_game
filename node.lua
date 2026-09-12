local ring_png = love.graphics.newImage("assets/ring_white.png")
local ring_width, ring_height = ring_png:getWidth(), ring_png:getHeight()
local arrow_png = love.graphics.newImage("assets/arrow.png")
local arrow_width, arrow_height = arrow_png:getWidth(), arrow_png:getHeight()

local coal_color = {64/256, 64/256, 64/256}

local directions = {
	UP = 1,
	DOWN = 2,
	LEFT = 3,
	RIGHT = 4,
}

local function node(x, y, alen)
	local node = {}
	node.x = x or 100
	node.y = y or 100
	node.ring1_rotation = 0
	node.centerOffsetX = 0
	node.centerOffsetY = 0
	node.cooldown_timer = 0
	node.cooldown_multiplier = 1

	local pattern = {}
	alen = alen or 10
	for _=1, alen do
		table.insert(pattern, math.random(1, 4))
	end

	function node:draw()
		love.graphics.setColor(coal_color)
		love.graphics.circle("fill", self.x+self.centerOffsetX, self.y+self.centerOffsetY, 45)
		local ring_scale = 0.5
		love.graphics.draw(ring_png, self.x, self.y, self.ring1_rotation, ring_scale, ring_scale, ring_width/2, ring_height/2)
		local arrow_direction = pattern[#pattern] or 1
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
		love.graphics.setColor(125/256, 230/256, 125/256)
		if self.cooldown_timer > 0 then
			love.graphics.setColor(1, 0, 0)
		end
		if #pattern >= 1 then
			love.graphics.draw(arrow_png, self.x+self.centerOffsetX, self.y+self.centerOffsetY, arrow_rotation, 0.1, 0.1, arrow_width/2, arrow_height/2)
		end
	end

	function node:update(dt)
		self.ring1_rotation = self.ring1_rotation + 5*dt
		self.centerOffsetX = self.centerOffsetX * math.pow(0.5, dt / 0.1)
		self.centerOffsetY = self.centerOffsetY * math.pow(0.5, dt / 0.1)
		if self.cooldown_timer > 0 then
			self.cooldown_timer = self.cooldown_timer - dt
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
		if pattern[#pattern] == directions.LEFT then
			self.centerOffsetX = -offset_amount
			self.centerOffsetY = 0
			table.remove(pattern, #pattern)
		else
			self:cooldown()
		end
	end

	function node:right()
		if pattern[#pattern] == directions.RIGHT then
			self.centerOffsetX = offset_amount
			self.centerOffsetY = 0
			table.remove(pattern, #pattern)
		else
			self:cooldown()
		end
	end

	function node:up()
		if pattern[#pattern] == directions.UP then
			self.centerOffsetX = 0
			self.centerOffsetY = -offset_amount
			table.remove(pattern, #pattern)
		else
			self:cooldown()
		end
	end

	function node:down()
		if pattern[#pattern] == directions.DOWN then
			self.centerOffsetX = 0
			self.centerOffsetY = offset_amount
			table.remove(pattern, #pattern)
		else
			self:cooldown()
		end
	end

	function node:cooldown()
		self.cooldown_timer = 0.5 * self.cooldown_multiplier
		if self.cooldown_multiplier < 3 then
			self.cooldown_multiplier = self.cooldown_multiplier + 1
		end
	end

	function node:completed()
		return #pattern == 0
	end

	return node
end


return node
