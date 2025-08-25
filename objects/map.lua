--- @class Map Create a global class called "Map".
--- @field tiles number[] The raw data table with zeros and ones.
--- @field columns number The number of tiles per column.
--- @field rows number The number of tiles per row.
--- @field cellSize number Each tile size.
--- @field ox number The grid offset x (width).
--- @field oy number The grid offset y (height).
Map = {}

--- Assign the metamethod "__index" as the same namespace. Provides a cheap and
--  simple way of implementing single inheritance. This will help us with
--  creating new "Map" objects.
Map.__index = Map

--- Create a new "Map" object by using metatable.
--- @param data table The raw data table with zeros and ones.
--- @param columns number The number of tiles per column.
--- @param rows number The number of tiles per row.
--- @return Map # The new "Map" object.
function Map:new(data, columns, rows)
    local this = {
        tiles = data,
        columns = columns,
        rows = rows,
        cellSize = 64,
    }

    setmetatable(this, self)

    -- Compute the grid width and height.
    this.gridWidth = this.columns * this.cellSize
    this.gridHeight = this.rows * this.cellSize

    -- Offset the grid drawing based on the window size (centering in the process).
    this.ox = love.graphics.getWidth() * 0.5 - this.gridWidth * 0.5
    this.oy = love.graphics.getHeight() * 0.5 - this.gridHeight * 0.5

    return this
end

--- Allow rendering the grid using Love2D graphics.
function Map:render()
    --- We start at zero to keep the first grid tile at the (x, y) = (0, 0)
    --  coordinate on our grid.
    for row = 0, self.rows - 1 do
        for col = 0, self.columns - 1 do
            --- sx is size in X axis. Add the offset "ox"
            local sx = col * self.cellSize + self.ox
            --- sy is size in Y axis. Add the offset "oy"
            local sy = row * self.cellSize + self.oy

            local tile = self:getTile(col, row)

            --- We need to draw each tile sprite based on its value.
            if tile > 0 then
                love.graphics.draw(TileTextures["grid"], TileQuads["grid"][tile], sx, sy)
            end

            -- if tile == 0 then
            --     love.graphics.rectangle("line", sx, sy, self.cellSize, self.cellSize)
            -- elseif tile == 1 then
            --     love.graphics.rectangle("fill", sx, sy, self.cellSize, self.cellSize)
            -- else
            --     love.graphics.setColor(1, 0, 0, 1) -- Red
            --     love.graphics.rectangle("fill", sx, sy, self.cellSize, self.cellSize)
            --     love.graphics.setColor(1, 1, 1, 1) -- Reset to white
            -- end

            --- Draw each tile as a rectangle (without fills).
            -- love.graphics.rectangle("line", sx, sy, self.cellSize, self.cellSize)
        end
    end
end

--- Obtain the tile by passing its x and y coordinates. Each tile index is
--  always "y" times our "width" plus the current "x" plus 1 (offset
--  because we started at zero).
--- @param x number coordinate in X (column)
--- @param y number coordinate in Y (row)
--- @return number # The tile value (0, 1, 2, etc)
function Map:getTile(x, y)
    --- Validate if the x and y coordinates are "out of bounds".
    if x < 0 or y < 0 or x > self.columns - 1 or y > self.rows - 1 then
        return -1
    end
    return self.tiles[y * self.columns + x + 1]
end

--- Set the tile value using its coordinates.
--- @param x number coordinate in X (column)
--- @param y number coordinate in Y (row)
--- @param tileType 1 | 2 | 3 The tile type, in this case, just a set of specific numbers.
--- @return boolean #
function Map:setTile(x, y, tileType)
    if x < 0 or y < 0 or x > self.columns - 1 or y > self.rows - 1 then
        return false
    end
    self.tiles[y * self.columns + x + 1] = tileType
    return true
end
