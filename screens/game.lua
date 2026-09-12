local Screen = require('screens.Screen')

local game = {}

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
	--node.centerOffsetX = 0
	--node.centerOffsetY = 0


	local pattern = {}
	alen = alen or 3
	for _=1, alen do
		table.insert(pattern, math.random(1, 4))
	end

	function node:draw()
		love.graphics.setColor(coal_color)
		love.graphics.circle("fill", self.x, self.y, 45)
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
		love.graphics.draw(arrow_png, self.x, self.y, arrow_rotation, 0.1, 0.1, arrow_width/2, arrow_height/2)
	end

	function node:update(dt)
		self.ring1_rotation = self.ring1_rotation + 5*dt
		--self.centerOffsetX = self.centerOffsetX * math.pow(0.5, dt / 0.1)
		--self.centerOffsetY = self.centerOffsetY * math.pow(0.5, dt / 0.1)
	end

	return node
end

function game.new()
	local self = Screen:new()

	local node1 = node(love.graphics.getWidth()/2, 2*love.graphics.getHeight()/3)

	function self:draw()
		love.graphics.push()
		node1:draw()
		love.graphics.pop()
	end

	function self:update(dt)
		node1:update(dt)
	end
	return self
end

return game
