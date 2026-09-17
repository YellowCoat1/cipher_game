local highscore_fs = {}

function highscore_fs.get()
	local info = love.filesystem.read("highscore")
	return info
end
function highscore_fs.get_spike()
	local info = love.filesystem.read("highscore_spikes")
	return info
end

function highscore_fs.set(hs)
	love.filesystem.write("highscore", tostring(hs))
end
function highscore_fs.set_spike(hs)
	love.filesystem.write("highscore_spikes", tostring(hs))
end

return highscore_fs
