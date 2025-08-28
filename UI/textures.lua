TileTextures = {
    ["grid"] = nil
}
TileQuads = {
    ["grid"] = nil
}

function LoadTextures()
    TileTextures["grid"] = love.graphics.newImage("assets/textures/tilesheet01.png")
    TileQuads["grid"] = CreateQuads(TileTextures["grid"], 64, 64)
end

--- Compute the texture image to split each "tile" into its own.
--- @param texture love.Image
--- @param tileWidth integer
--- @param tileHeight integer
--- @return love.Quad[] # The quads
function CreateQuads(texture, tileWidth, tileHeight)
    if tileWidth <= 0 then
        error("Invalid tile width")
    elseif tileHeight <= 0 then
        error("Invalid tile height")
    end

    local quads = {}

    local rows = texture:getHeight() / tileHeight
    local cols = texture:getWidth() / tileWidth

    for j = 0, rows - 1 do
        for i = 0, cols - 1 do
            local quad = love.graphics.newQuad(
                i * tileWidth,
                j * tileHeight,
                tileWidth,
                tileHeight,
                texture:getDimensions()
            )

            table.insert(quads, quad)
        end
    end

    return quads
end

--- @type love.Image[]
TileSprites = {}

function LoadTileSprites()
    for i = 0, 34 do
        local filename = string.format("assets/textures/tilemap/tile-%d.png", i)
        local newTile = love.graphics.newImage(filename)

        table.insert(TileSprites, newTile)
    end
end
