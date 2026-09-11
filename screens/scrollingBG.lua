local Screen = require('screens.Screen')
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

	function self:draw()
		love.graphics.push()
		love.graphics.setColor(0.6, 0.6, 0.6, 1)
		local width, height = love.graphics.getWidth(), love.graphics.getHeight()
		drawHexGrid(width+5*sideLength, 0, width/(2*sideLength*cos60), height/(2*sideLength*cos60))
		love.graphics.pop()
	end

	function self:update()
		--y = y + math.sin(90-43.9)
		--x = x + math.cos(90-43.9)
	end
	return self
end


return scrollingBackground
