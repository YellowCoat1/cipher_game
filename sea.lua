local sea = {}

local line_len = 30
local space_len = 10

local negative_primary = {148/255,102/255,1/255}
local negative_secondary = {238/255,226/255,0/255}


function sea.new(ylevel)
	local self = {}
	self.ylevel = ylevel or love.graphics.getHeight()-50
	self.offset = 0
	function self:draw(yOffset)
		yOffset = yOffset or 0

		local effective_y = self.ylevel + yOffset
		local height, width = love.graphics.getHeight(), love.graphics.getWidth()
		if effective_y > height+10 then
			return
		end
		love.graphics.setColor(negative_primary)
		local total_lines = width/(line_len + space_len)
		for i=-3,total_lines+3,1 do
			love.graphics.line(i*(line_len+space_len)+self.offset, self.ylevel+yOffset, i*(line_len+space_len)+line_len+self.offset, self.ylevel+yOffset)
		end
		love.graphics.setColor(negative_secondary[1], negative_secondary[2], negative_secondary[3], 0.4)
		love.graphics.rectangle("fill", 0, self.ylevel+yOffset, width, height)
	end
	function self:update(dt)
		self.offset = self.offset + 100*dt
		if self.offset > line_len + space_len then
			self.offset = self.offset - (line_len + space_len)
		 end
	end

	return self
end


return sea
