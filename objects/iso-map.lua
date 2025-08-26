--- @class IsometricMap Create a global class called "IsometricMap".
--- @field tiles number[][] The raw data table with zeros and ones.
--- @field columns number The number of tiles per column.
--- @field rows number The number of tiles per row.
--- @field tileWidth number The fixed tile width (100 pixels)
--- @field tileHeight number The fixed tile height (50 pixels)
--- @field ox number The grid offset x (width).
--- @field oy number The grid offset y (height).
IsometricMap = {}

--- Assign the metamethod "__index" as the same namespace. Provides a cheap and
--  simple way of implementing single inheritance. This will help us with
--  creating new "IsometricMap" objects.
IsometricMap.__index = IsometricMap

--- Maximum individual tile height for the map.
MAX_MAP_TILE_HEIGHT = 80

--- Create a new "IsometricMap" object by using metatable.
--- @param tiles number[][] The raw tiles 2D array with zeros and ones.
--- @return IsometricMap # The new "IsometricMap" object.
function IsometricMap:new(tiles)
    local this = {
        tiles = tiles,
        rows = #tiles,
        columns = #tiles[1],
        tileWidth = 100,
        tileHeight = 50
    }

    setmetatable(this, self)

    --- Offset the grid drawing based on the window size (centering in the
    -- process).
    this.ox = love.graphics.getWidth() * 0.5 - this.tileWidth * 0.5
    this.oy = this.tileHeight

    return this
end

--- Allow rendering the grid using Love2D graphics.
function IsometricMap:render()
    --- We start at zero to keep the first grid tile at the (x, y) = (0, 0)
    --  coordinate on our grid.
    for row = 1, self.rows do
        for col = 1, self.columns do
            --- sx is size in X axis. Add the offset "ox".
            local sx = self.ox + (col - row) * self.tileWidth * 0.5
            --- sy is size in Y axis. Add the offset "oy".
            local sy = self.oy + (col + row) * self.tileHeight * 0.5

            --- We must offset by one as the TileSprites starts at index 1.
            local tile = self:getTile(col, row) + 1

            --- We need to draw each tile sprite based on its value. As some
            --  tiles have different heights, we must take into account the
            --  "z-axis offset" to correct the height differences.
            if tile > 0 then
                local tileImage = TileSprites[tile]
                local oz = MAX_MAP_TILE_HEIGHT - tileImage:getHeight()

                love.graphics.draw(TileSprites[tile], sx, sy + oz)
            end
        end
    end
end

--- Obtain the tile by passing its x and y coordinates. Each tile index is
--  always "y" times our "width" plus the current "x" plus 1 (offset
--  because we started at zero).
--- @param x number coordinate in X (column)
--- @param y number coordinate in Y (row)
--- @return number # The tile value (0, 1, 2, etc)
function IsometricMap:getTile(x, y)
    --- Validate if the x and y coordinates are "out of bounds".
    if x < 1 or y < 1 or x > self.columns or y > self.rows then
        return -1
    end
    return self.tiles[y][x]
end

--- Set the tile value using its coordinates.
--- @param x number coordinate in X (column)
--- @param y number coordinate in Y (row)
--- @param tileType 1 | 2 | 3 The tile type, in this case, just a set of specific numbers.
--- @return boolean #
function IsometricMap:setTile(x, y, tileType)
    if x < 1 or y < 1 or x > self.columns or y > self.rows then
        return false
    end
    self.tiles[y][x] = tileType
    return true
end
