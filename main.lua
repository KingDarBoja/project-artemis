require "UI.textures"
require "map.helpers"
require "map.isometric_map"

--- Load tile textures.
LoadTileSprites()

--- Switch to false to use the true height differences case.
FlatExample = true

--- @type number[][]
local tiles = FlatExample and {
  --- Flat surface example
  { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
  { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
  { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
  { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
  { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
  { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
  { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
  { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
  { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
  { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
} or {
  --- Height difference example
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

--- Create the map after loading the textures!
local gameMap = IsometricMap:new(tiles)

--- Variable to store the previous "hovered" tile.
--- @type MapTile
local prevTile = nil

---
--- @type integer, integer
local prevTileX, prevTileY = -1, -1

--- Store the current mouse screen coordinates.
--- @type integer, integer
local MouseX, MouseY = nil, nil

--- Store the current grid coordinates.
--- @type integer, integer
local TileX, TileY = nil, nil

--- One-time setup of the game.
function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')

  --- Needed to initialize the grid tiles images.
  gameMap:createTiles()

  -- Set default background color to #282d34 (40, 45, 52).
  local r, g, b = love.math.colorFromBytes(40, 45, 52)
  love.graphics.setBackgroundColor(r, g, b)
end

--- Manage the game state frame-to-frame.
--- @param dt number Time since the last update in seconds.
function love.update(dt)
  MouseX, MouseY = love.mouse.getPosition()
  TileX, TileY = ToGridCoordinate(gameMap, MouseX, MouseY)

  --- Perform the check of the hover state.
  local currentTile = gameMap:getTile(TileX, TileY)
  if currentTile ~= prevTile then
    if prevTile then
      prevTile:setHighlight()
      prevTileX, prevTileY = prevTile.pos.row, prevTile.pos.col
      gameMap:setTile(prevTile.pos.row, prevTile.pos.col, prevTile)
    end

    currentTile:setHighlight()
    prevTile = currentTile
  end
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

  love.graphics.printf(
    string.format('Current tile coordinates - (X, Y): (%d, %d)', TileX, TileY),
    0,
    50,
    love.graphics:getWidth(),
    'center'
  )

  love.graphics.printf(
    string.format('Previous tile coordinates - (X, Y): (%d, %d)', prevTileX, prevTileY),
    0,
    70,
    love.graphics:getWidth(),
    'center'
  )

  gameMap:render()
end
