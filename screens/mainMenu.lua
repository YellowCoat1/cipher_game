local Screen = require('screens.Screen')

local MainScreen = {}

function MainScreen.new()
    local self = Screen.new()

    function self:draw()
        love.graphics.print("man i love main screens", 0, 0)
    end

    function self:update(dt)
    end

    return self
end

return MainScreen
