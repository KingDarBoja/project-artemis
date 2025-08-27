--- @class IsometricMap Create a global class called "IsometricMap".
--- @field grid number[][] The raw data table with zeros and ones.
--- @field columns number The number of tiles per column.
--- @field rows number The number of tiles per row.
--- @field tileWidth number The fixed tile width (100 pixels)
--- @field tileHeight number The fixed tile height (50 pixels)
--- @field ox number The grid screen offset x (width).
--- @field oy number The grid screen offset y (height).
--- @field tiles IsometricMapTile[]
IsometricMap = {}

--- Assign the metamethod "__index" as the same namespace. Provides a cheap and
--  simple way of implementing single inheritance. This will help us with
--  creating new "IsometricMap" objects.
IsometricMap.__index = IsometricMap

-- Default tile width
MAP_TILE_WIDTH = 100
-- Default tile height
MAP_TILE_HEIGHT = 50

--- Maximum individual tile height for the map.
MAX_MAP_TILE_HEIGHT = 80

--- Create a new "IsometricMap" object by using metatable.
--- @param grid number[][] The raw tiles 2D array with zeros and ones.
--- @return IsometricMap # The new "IsometricMap" object.
function IsometricMap:new(grid)
    local this = {
        grid = grid,
        rows = #grid[1],
        columns = #grid,
        tileWidth = MAP_TILE_WIDTH,
        tileHeight = MAP_TILE_HEIGHT
    }

    setmetatable(this, self)

    --- Offset the grid drawing based on the window size (centering in the
    -- process).
    this.ox = love.graphics.getWidth() * 0.5 - this.tileWidth * 0.5
    this.oy = this.tileHeight

    return this
end

-- --- Allow rendering the grid using Love2D graphics.
-- function IsometricMap:render()
--     --- We start at zero to keep the first grid tile at the (x, y) = (0, 0)
--     --  coordinate on our grid.
--     for row = 0, self.rows - 1 do
--         for col = 0, self.columns - 1 do
--             --- sx is screen position in X axis. Add the offset "ox".
--             local sx = self.ox + (col - row) * self.tileWidth * 0.5
--             --- sy is screen position in Y axis. Add the offset "oy".
--             local sy = self.oy + (col + row) * self.tileHeight * 0.5

--             --- We must offset by one as the TileSprites starts at index 1.
--             local tile = self:getTile(col, row) + 1

--             --- We need to draw each tile sprite based on its value. As some
--             --  tiles have different heights, we must take into account the
--             --  "z-axis offset" to correct the height differences.
--             if tile > 0 then
--                 local tileImage = TileSprites[tile]
--                 local oz = MAX_MAP_TILE_HEIGHT - tileImage:getHeight()

--                 love.graphics.draw(TileSprites[tile], sx, sy + oz)
--                 love.graphics.printf(string.format('[%d, %d]', col, row), sx, sy + oz * 1.5, MAP_TILE_WIDTH, 'center')
--                 -- love.graphics.rectangle('line', sx, sy, MAP_TILE_WIDTH, MAP_TILE_HEIGHT)
--             end
--         end
--     end
-- end

--- Allow rendering the grid using Love2D graphics.
function IsometricMap:render()
    --- @type IsometricMapTile[]
    local tiles = {}
    for row = 1, self.rows do
        for col = 1, self.columns do
            local tile = IsometricMapTile:new(
                self,
                { row = row, col = col }
            )

            table.insert(tiles, tile)

            tile:render()
        end
    end

    self.tiles = tiles
end

--- Obtain the tile by passing its x and y coordinates. Each tile index is
--  always "y" times our "width" plus the current "x" plus 1 (offset
--  because we started at zero).
--- @param x number coordinate in X (row)
--- @param y number coordinate in Y (column)
--- @return number # The tile value (0, 1, 2, etc)
function IsometricMap:getTile(x, y)
    --- Validate if the x and y coordinates are "out of bounds".
    if x < 1 or y < 1 or x > self.columns or y > self.rows then
        return -1
    end
    return self.grid[y][x]
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
    self.grid[y][x] = tileType
    return true
end

--- @class IsometricMapTile
--- @field tValue number The tile value to render the image.
--- @field tImage love.Image The tile image.
--- @field tw number The tile width (100 pixels by default).
--- @field th number The tile height (50 pixels by default).
--- @field sx number Screen position in X axis (cartesian).
--- @field sy number Screen position in Y axis (cartesian).
--- @field oz number The Z-axis screen offset, to simulate the height differences.
--- @field pos {row: number, col: number} The tile [row, col] position in the grid (i-axis, j-axis).
IsometricMapTile = {}
IsometricMapTile.__index = IsometricMapTile

--- comment
--- @param map IsometricMap The isometric map.
--- @param pos {row: number, col: number} The tile [row, col] position in the grid (i-axis, j-axis).
--- @return IsometricMapTile #
function IsometricMapTile:new(map, pos)
    --- We must offset by one as the TileSprites starts at index 1.
    local tileValue = map:getTile(pos.row, pos.col) + 1
    local tileImage = TileSprites[tileValue]
    local tw = MAP_TILE_WIDTH
    local th = MAP_TILE_HEIGHT

    local this = {
        tValue = tileValue,
        tImage = tileImage,
        pos = {
            row = pos.row,
            col = pos.col,
        },
        tw = tw,
        th = th,
        sx = map.ox + (pos.row - pos.col) * tw * 0.5,
        sy = map.oy + (pos.row + pos.col) * th * 0.5,
        oz = MAX_MAP_TILE_HEIGHT - tileImage:getHeight(),
    }

    setmetatable(this, self)

    return this
end

--- Render a single map tile.
function IsometricMapTile:render()
    --- Draw the tile image in the screen.
    love.graphics.draw(self.tImage, self.sx, self.sy)

    -- love.graphics.rectangle('line', self.sx, self.sy, self.tw, self.th)

    --- Draw the tile coordinate (i, j) in the screen.
    love.graphics.printf(
        string.format('[%d, %d]', self.pos.row, self.pos.col),
        self.sx,
        self.sy,
        MAP_TILE_WIDTH,
        'center',
        nil,
        nil,
        nil,
        nil,
        -0.5 * MAP_TILE_HEIGHT
    )

    local lx, ly = self.tw * 0.5 + self.sx - self.tw * 0.5, self.th * 0.5 + self.sy
    local tx, ty = self.tw * 0.5 + self.sx, self.th * 0.5 + self.sy - self.th * 0.5
    local rx, ry = self.tw * 0.5 + self.sx + self.tw * 0.5, self.th * 0.5 + self.sy
    local bx, by = self.tw * 0.5 + self.sx, self.th * 0.5 + self.sy + self.th * 0.5

    love.graphics.polygon('line', lx, ly, tx, ty, rx, ry, bx, by)

    --- Draw the tile vertices.
    love.graphics.setColor(1, 0, 0)
    love.graphics.setPointSize(4)
    love.graphics.points(lx, ly, tx, ty, rx, ry, bx, by)
    love.graphics.setColor(1, 1, 1)
end
