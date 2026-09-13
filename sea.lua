local sea = {}
local offset = 0

local line_len = 30
local space_len = 10
local ylevel = love.graphics.getHeight()-50

local negative_primary = {148/255,102/255,1/255}
local negative_secondary = {238/255,226/255,0/255}

function sea:draw()
	love.graphics.setColor(negative_primary)
	local total_lines = love.graphics.getWidth()/(line_len + space_len)
	for i=-3,total_lines+3,1 do
		love.graphics.line(i*(line_len+space_len)+offset, ylevel, i*(line_len+space_len)+line_len+offset, ylevel)
	end
	love.graphics.setColor(negative_secondary[1], negative_secondary[2], negative_secondary[3], 0.4)
	love.graphics.rectangle("fill", 0, ylevel, love.graphics.getWidth(), 10+love.graphics.getHeight()-ylevel)
end

function sea:update(dt)
	offset = offset + 100*dt
	if offset > line_len + space_len then
		offset = offset - (line_len + space_len)
	 end
end


return sea
