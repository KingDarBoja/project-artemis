require 'map.constants'
require 'map.isometric_tile'

--- @class IsometricMap Create a global class called "IsometricMap".
--- @field grid number[][] The raw data table with zeros and ones.
--- @field columns number The number of tiles per column.
--- @field rows number The number of tiles per row.
--- @field tileWidth number The fixed tile width (100 pixels)
--- @field tileHeight number The fixed tile height (50 pixels)
--- @field ox number The grid screen offset x (width).
--- @field oy number The grid screen offset y (height).
--- @field tiles MapTile[][]
IsometricMap = {}

--- Create a new "IsometricMap" object by using metatable.
--- @param grid number[][] The raw tiles 2D array with zeros and ones.
--- @return IsometricMap # The new "IsometricMap" object.
function IsometricMap:new(grid)
    local this = {
        grid = grid,
        rows = #grid[1],
        columns = #grid,
        tileWidth = MAP_TILE_WIDTH,
        tileHeight = MAP_TILE_HEIGHT,
    }

    setmetatable(this, self)
    --- Assign the metamethod "__index" as the same namespace. Provides a cheap and
    --  simple way of implementing single inheritance.
    self.__index = self

    --- Offset the grid drawing based on the window size (centering in the
    -- process).
    this.ox = love.graphics.getWidth() * 0.5 - this.tileWidth * 0.5
    this.oy = this.tileHeight

    return this
end

--- Create the tiles with all the needed data.
function IsometricMap:createTiles()
    --- @type MapTile[][]
    local tiles = {}
    for row = 1, self.rows do
        --- Assign a new inner table for each row.
        tiles[row] = {}
        for col = 1, self.columns do
            local tValue = self:getTileValue(row, col)

            local tile = MapTile:new(
                { row = row, col = col },
                { x = self.ox, y = self.oy },
                tValue
            )

            tiles[row][col] = tile
        end
    end

    self.tiles = tiles
end

--- Allow rendering the grid using Love2D graphics.
function IsometricMap:render()
    for row = 1, self.rows do
        for col = 1, self.columns do
            local tile = self:getTile(row, col)
            tile:render()
        end
    end
end

--- Obtain the tile value by its x and y coordinates.
--- @param x integer coordinate in X (row)
--- @param y integer coordinate in Y (column)
--- @return integer # The tile value (0, 1, 2, etc)
function IsometricMap:getTileValue(x, y)
    --- Validate if the x and y coordinates are "out of bounds".
    if x < 1 or y < 1 or x > self.rows or y > self.columns then
        return -1
    end
    --- We must offset by one as the TileSprites starts at index 1.
    return self.grid[x][y] + 1
end

--- Set the tile value by its coordinates.
--- @param x integer coordinate in X (row)
--- @param y integer coordinate in Y (column)
--- @param tileType integer The tile type, in this case, just a set of specific numbers.
--- @return boolean #
function IsometricMap:setTileValue(x, y, tileType)
    if x < 1 or y < 1 or x > self.rows or y > self.columns then
        return false
    end
    self.grid[x][y] = tileType
    return true
end

--- comment
--- @param x integer
--- @param y integer
--- @param newTile MapTile
--- @return boolean
function IsometricMap:setTile(x, y, newTile)
    if x < 1 or y < 1 or x > self.rows or y > self.columns then
        return false
    end
    self.tiles[x][y] = newTile
    return true
end

--- Obtain the tile object by passing its x and y coordinates. Clamp the
--  selection to only the max row or column.
--- @param x integer coordinate in X (row)
--- @param y integer coordinate in Y (column)
--- @return MapTile # The tile object
function IsometricMap:getTile(x, y)
    --- Validate if the x and y coordinates are "out of bounds".
    local newX, newY = x, y
    if x < 1 then
        newX = 1
    elseif x > self.rows then
        newX = self.rows
    end
    if y < 1 then
        newY = 1
    elseif y > self.columns then
        newY = self.columns
    end
    --- We must offset by one as the TileSprites starts at index 1.
    return self.tiles[newX][newY]
end
