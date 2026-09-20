local Screen = require('screens.Screen')
local scrollingBackground = {}

local sideLength = 20
local sin60 = math.sin(math.rad(60))
local cos60 = math.cos(math.rad(60))

local hex_grid
local canvas

local function chunk(x, y)
	x = math.floor(x)
	y = math.floor(y)
	love.graphics.draw(hex_grid, x, y, 0, 1/2, 1/2)
end
local function drawHexGrid(xOffset, yOffset)
	local hex_height, hex_width = hex_grid:getHeight()/2, hex_grid:getWidth()/2 - 1
	local chunks_across =  love.graphics.getWidth() / hex_width
	local chunks_below =  love.graphics.getHeight() / hex_height
	for i=0,chunks_across do
		for j=0,chunks_below do
			chunk(-50 + xOffset + i*hex_width, -50 + yOffset + j*hex_height)
		end
	end
end

function scrollingBackground.new()
	local self = Screen.new()

	self.xOffset = 0
	self.yOffset = 0

	hex_grid = love.graphics.newImage('assets/hex.png')
	canvas = love.graphics.newCanvas()

	function self:draw()
		love.graphics.push()
		love.graphics.setCanvas(canvas)
		love.graphics.clear()
		love.graphics.setColor(0.75, 0.75, 0.8, 1)
		love.graphics.setLineWidth(1)
		love.graphics.setDefaultFilter("nearest", "nearest")
		drawHexGrid(self.xOffset, self.yOffset)
		love.graphics.setCanvas()
		love.graphics.draw(canvas, 0, 0)
		love.graphics.pop()
	end

	local scrollSpeed = 15
	local scrollX = sin60
	local scrollY = cos60
	function self:update(dt)
		self.xOffset = self.xOffset + dt*scrollX*scrollSpeed
		self.yOffset = self.yOffset + dt*scrollY*scrollSpeed

		if self.xOffset > 3*sideLength*sin60 then
			self.xOffset = self.xOffset - 3*sideLength*sin60
			self.yOffset = self.yOffset - 3*sideLength*cos60
		end
	end
	return self
end


return scrollingBackground
