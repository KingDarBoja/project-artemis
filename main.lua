require "objects.map"
require "UI.textures"

local tiles = {
    1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 11, 1, 3, 1,
    1, 12, 3, 3, 11, 1, 3, 1,
    1, 12, 3, 3, 11, 1, 3, 1,
    1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 4, 4, 4, 3, 3, 4,
}

local grid = Map:new(tiles, 8, 6)

LoadTextures()

--- One-time setup of the game.
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Set default background color to #282d34 (40, 45, 52).
    local r, g, b = love.math.colorFromBytes(40, 45, 52)
    love.graphics.setBackgroundColor(r, g, b)

    -- Updating a tile as example
    grid:setTile(1, 1, 2)
end

--- Manage the game state frame-to-frame.
--- @param dt number Time since the last update in seconds.
function love.update(dt)

end

--- Draw on the screen every frame.
function love.draw()
    -- love.graphics.print('Hello Love2D!')

    grid:render()
end
