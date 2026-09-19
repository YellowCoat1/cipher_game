local Screen = require('screens.Screen')
local prof = require('libs.jprof')
local scrollingBackground = {}

local sideLength = 20
local sin60 = math.sin(math.rad(60))
local cos60 = math.cos(math.rad(60))

local function drawHexChunk(x, y)
	local x1, y1 = x-(sideLength*sin60), y-(sideLength*cos60)
	local x2, y2 = x1-(sideLength*sin60), y1+(sideLength*cos60)
	local x3, y3 = x2, y2+sideLength
	love.graphics.line(x, y, x1, y1, x2, y2, x3, y3)
	return x2, y2
end

local function drawHexLine(x, y, n)
	local lineX, lineY = x, y
	for _ = 1, n, 1 do
		lineX, lineY = drawHexChunk(lineX, lineY)
	end
end

local function drawHexGrid(x, y, w, h)
	local columnX, columnY = x, y
	local offset_right = false
	for _=1,h do
		drawHexLine(columnX, columnY, w)
		columnX, columnY = columnX, columnY+sideLength
		if not offset_right then
			columnX, columnY = columnX-sideLength*sin60, columnY+sideLength*cos60
			offset_right = not offset_right
		else
			columnX, columnY = columnX+sideLength*sin60, columnY+sideLength*cos60
			offset_right = not offset_right
		end
	end
end

function scrollingBackground.new()
	local self = Screen.new()

	self.xOffset = 0
	self.yOffset = 0

	function self:draw()
		prof.push("hex grid draw")
		love.graphics.push()
		love.graphics.setColor(0.75, 0.75, 0.8, 1)
		love.graphics.setLineWidth(1)
		local width, height = love.graphics.getWidth(), love.graphics.getHeight()
		drawHexGrid(width+5*sideLength+self.xOffset, self.yOffset-100, 5+width/(2*sideLength*cos60), 5+height/(2*sideLength*cos60))
		love.graphics.pop()
		prof.pop("hex grid draw")
	end

	local scrollSpeed = 15
	local scrollX = sin60
	local scrollY = cos60
	function self:update(dt)
		prof.push("hex grid calc")
		self.xOffset = self.xOffset + dt*scrollX*scrollSpeed
		self.yOffset = self.yOffset + dt*scrollY*scrollSpeed

		if self.xOffset > 3*sideLength*sin60 then
			self.xOffset = self.xOffset - 3*sideLength*sin60
			self.yOffset = self.yOffset - 3*sideLength*cos60
		end
		prof.pop("hex grid calc")
	end
	return self
end


return scrollingBackground
