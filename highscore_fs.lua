local highscore_fs = {}

function highscore_fs.get()
	local info = love.filesystem.read("highscore")
	return info
end

function highscore_fs.set(hs)
	love.filesystem.write("highscore", tostring(hs))
end


return highscore_fs
