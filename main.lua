require "objects.map"
require "objects.iso-map"
require "UI.textures"

--- @type number[]
-- local tiles = {
--     1, 1, 1, 1, 1, 1, 1, 1,
--     1, 1, 1, 1, 11, 1, 3, 1,
--     1, 12, 3, 3, 11, 1, 3, 1,
--     1, 12, 3, 3, 11, 1, 3, 1,
--     1, 1, 1, 1, 1, 1, 1, 1,
--     1, 1, 4, 4, 4, 3, 3, 4,
-- }

--- @type number[][]
local tiles = {
  -- {2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
  -- {2, 0, 0, 0, 0, 0, 0, 0, 0, 2},
  -- {2, 0, 0, 0, 0, 0, 0, 0, 0, 2},
  -- {2, 0, 0, 0, 0, 0, 0, 0, 0, 2},
  -- {2, 0, 0, 1, 0, 0, 0, 0, 0, 2},
  -- {2, 0, 0, 1, 0, 0, 0, 0, 0, 2},
  -- {2, 0, 0, 0, 0, 0, 0, 0, 0, 2},
  -- {2, 0, 0, 0, 0, 0, 0, 1, 0, 2},
  -- {2, 0, 0, 0, 0, 0, 0, 0, 0, 2},
  -- {2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
  { 14, 23, 23, 23, 23, 23, 23, 23, 23, 13 },
  { 21, 32, 33, 33, 28, 33, 28, 33, 31, 20 },
  { 21, 34, 0,  0,  25, 33, 30, 1,  34, 20 },
  { 21, 34, 0,  0,  34, 1,  1,  10, 34, 20 },
  { 21, 25, 33, 33, 24, 33, 33, 33, 27, 20 },
  { 21, 34, 4,  7,  34, 18, 17, 10, 34, 20 },
  { 21, 34, 4,  7,  34, 16, 19, 10, 34, 20 },
  { 21, 34, 6,  8,  34, 10, 10, 10, 34, 20 },
  { 21, 29, 33, 33, 26, 33, 33, 33, 30, 20 },
  { 11, 22, 22, 22, 22, 22, 22, 22, 22, 12 },
}

-- LoadTextures()
LoadTileSprites()

--- Create the map after loading the textures!
-- local gameMap = Map:new(tiles, 8, 6)
local gameMap = IsometricMap:new(tiles)

--- One-time setup of the game.
function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  -- Set default background color to #282d34 (40, 45, 52).
  local r, g, b = love.math.colorFromBytes(40, 45, 52)
  love.graphics.setBackgroundColor(r, g, b)
end

--- Manage the game state frame-to-frame.
--- @param dt number Time since the last update in seconds.
function love.update(dt)
  MouseX, MouseY = love.mouse.getPosition()
end

--- Draw on the screen every frame.
function love.draw()
  love.graphics.printf('Example Isometric Grid', 0, 10, love.graphics:getWidth(), 'center')

  love.graphics.printf(
    string.format('Mouse coordinates - (X, Y): (%d, %d)', MouseX, MouseY),
    0,
    30,
    love.graphics:getWidth(),
    'center'
  )

  local tileX, tileY = ToGridCoordinate(gameMap, MouseX, MouseY)

  love.graphics.printf(
    string.format('Tile coordinates - (X, Y): (%d, %d)', tileX, tileY),
    0,
    50,
    love.graphics:getWidth(),
    'center'
  )

  gameMap:render()
end

--- Convert from the mouse screen coordinates into the grid tile coordinates.
--- @param grid IsometricMap The mouse screen position in the X axis.
--- @param screenX number The mouse screen position in the X axis.
--- @param screenY number The mouse screen position in the Y axis.
--- @return number x # The cartesian X coordinates.
--- @return number y # The cartesian Y coordinates.
function ToGridCoordinate(grid, screenX, screenY)
  local i_x = 1
  local i_y = 0.5
  local j_x = -1
  local j_y = 0.5

  --- Multiply the map tile height by two as the ratio with the width is the half.
  local a = i_x * 0.5 * MAP_TILE_WIDTH
  local b = j_x * 0.5 * MAP_TILE_WIDTH
  local c = i_y * 0.5 * MAP_TILE_HEIGHT * 2
  local d = j_y * 0.5 * MAP_TILE_HEIGHT * 2

  --- The determinant of the matrix.
  local determinant = (1 / ((a * d) - (b * c)))

  local adjointA = determinant * a
  local adjointB = determinant * -b
  local adjointC = determinant * -c
  local adjointD = determinant * d

  --- Account for the screen offset. Counter the offset in the X-axis due to the
  -- half of the tile width used for the centering.
  local sx = grid.ox + grid.tileWidth * 0.5
  local sy = grid.oy

  --- Account for the grid offset (in quantity of tiles).
  local offset = {
    x = 0,
    y = 0,
  }

  local x = math.floor((screenX - sx) * adjointD + (screenY - sy) * adjointB + offset.x)
  local y = math.floor((screenX - sx) * adjointC + (screenY - sy) * adjointA + offset.y)

  return x, y
end
