local Screen = require('screens.Screen')

local game = {}

local ring_png = love.graphics.newImage("assets/ring_white.png")
local ring_width, ring_height = ring_png:getWidth(), ring_png:getHeight()

local coal_color = {64/256, 64/256, 64/256}

local function node(x, y)
	local node = {}
	node.x = x or 100
	node.y = y or 100
	node.ring1_rotation = 0

	function node:draw()
		love.graphics.setColor(coal_color)
		love.graphics.circle("fill", self.x, self.y, 45)
		local ring_scale = 0.5
		love.graphics.draw(ring_png, self.x, self.y, self.ring1_rotation, ring_scale, ring_scale, ring_width/2, ring_height/2)
	end

	function node:update(dt)
		self.ring1_rotation = self.ring1_rotation + 5*dt
	end

	return node
end

function game.new()
	local self = Screen:new()

	local node1 = node(200, 200)

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
