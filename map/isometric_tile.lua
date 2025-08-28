require 'map.constants'

--- @class MapTile
--- @field tValue number The tile value to render the image.
--- @field tImage love.Image The tile image.
--- @field tw number The tile width (100 pixels by default).
--- @field th number The tile height (50 pixels by default).
--- @field sx number Screen position in X axis (cartesian).
--- @field sy number Screen position in Y axis (cartesian).
--- @field oz number The Z-axis screen offset, to simulate the height differences.
--- @field highlighted boolean Flag to control if the tile is being highlighted (mouse over).
--- @field pos {row: number, col: number} The tile [row, col] position in the grid (i-axis, j-axis).
MapTile = {}

--- comment
--- @param pos {row: number, col: number} The tile [row, col] position in the grid (i-axis, j-axis).
--- @param offset { x: number, y: number} The map screen offsets.
--- @param val number The tile value within the map.
--- @return MapTile #
function MapTile:new(pos, offset, val)
    local tileImage = TileSprites[val]
    local tw = MAP_TILE_WIDTH
    local th = MAP_TILE_HEIGHT

    local this = {
        highlighted = false,
        tValue = val,
        tImage = tileImage,
        pos = {
            row = pos.row,
            col = pos.col,
        },
        tw = tw,
        th = th,
        sx = offset.x + (pos.row - pos.col) * tw * 0.5,
        sy = offset.y + (pos.row + pos.col) * th * 0.5,
        oz = MAX_MAP_TILE_HEIGHT - tileImage:getHeight(),
    }

    setmetatable(this, self)
    self.__index = self

    return this
end

--- Aaaaah
--- @param val integer
function MapTile:updateValue(val)
    local tileImage = TileSprites[val]
    self.tImage = tileImage
    self.tValue = val
    self.oz = MAX_MAP_TILE_HEIGHT - tileImage:getHeight()
end

--- Render a single map tile.
function MapTile:render()
    --- Draw the tile image in the screen.
    love.graphics.draw(self.tImage, self.sx, self.sy + (FlatExample and 0 or self.oz))

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

    -- love.graphics.printf(
    --     string.format('oz: %d', self.oz),
    --     self.sx,
    --     self.sy,
    --     MAP_TILE_WIDTH,
    --     'center',
    --     nil,
    --     nil,
    --     nil,
    --     nil,
    --     -0.5 * MAP_TILE_HEIGHT
    -- )

    local lx, ly = self.tw * 0.5 + self.sx - self.tw * 0.5, self.th * 0.5 + self.sy + (FlatExample and 0 or self.oz)
    local tx, ty = self.tw * 0.5 + self.sx, self.th * 0.5 + self.sy - self.th * 0.5 + (FlatExample and 0 or self.oz)
    local rx, ry = self.tw * 0.5 + self.sx + self.tw * 0.5, self.th * 0.5 + self.sy + (FlatExample and 0 or self.oz)
    local bx, by = self.tw * 0.5 + self.sx, self.th * 0.5 + self.sy + self.th * 0.5 + (FlatExample and 0 or self.oz)

    love.graphics.polygon(self.highlighted and 'fill' or 'line', lx, ly, tx, ty, rx, ry, bx, by)

    --- Draw the tile vertices.

    love.graphics.setColor(1, 0, 0)
    love.graphics.setPointSize(4)
    love.graphics.points(lx, ly, tx, ty, rx, ry, bx, by)
    love.graphics.setColor(1, 1, 1)
end

function MapTile:setHighlight()
    self.highlighted = self.highlighted and false or true
end