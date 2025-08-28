require 'map.constants'

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

  --- Account for the tile offset in the Y-axis (z-offset).
  local oz = -MAX_MAP_TILE_HEIGHT + MAP_TILE_HEIGHT

  -- local x = math.floor((screenX - sx) * adjointD + (screenY - sy + oz) * adjointB)
  -- local y = math.floor((screenX - sx) * adjointC + (screenY - sy + oz) * adjointA)
  local x = math.floor((screenX - sx) * adjointD + (screenY - sy) * adjointB)
  local y = math.floor((screenX - sx) * adjointC + (screenY - sy) * adjointA)

  return x, y
end
