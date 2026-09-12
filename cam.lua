local scrollFactor = 1
local function cam()
	local cam = {}
	cam.currentX = 0
	cam.currentY = 0
	cam.targetX = 0
	cam.targetY = 0

	function cam:newTarget(x, y)
		cam.targetX, cam.targetY = x, y
	end

	function cam:update(dt)
		self.currentX = (self.currentX - self.targetX) * math.pow(0.5, dt / scrollFactor) + self.targetX
	end

	function cam:offset()
		return cam.currentX, cam.currentY
	end
	return cam
end

return cam
