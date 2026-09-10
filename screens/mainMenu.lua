-- MainScreen.lua

local Screen = require('screens.Screen')

local MainScreen = {}

function MainScreen.new()
    local self = Screen.new()

    local x, y, w, h = 20, 20, 40, 20

    function self:draw()
        love.graphics.rectangle('fill', x, y, w, h)
    end

    function self:update(dt)
        w = w + 2
        h = h + 1
    end

    return self
end

return MainScreen
