---@meta

--- @enum (key) FULL_SCREEN_TYPE
local FULL_SCREEN_TYPE = {
    desktop = 1,
    exclusive = 2,
}

--- @class LoveConfigWindows
--- @field title string The window title (string)
--- @field icon string | nil Filepath to an image to use as the window's icon (string)
--- @field width number The window width (number)
--- @field height number The window height (number)
--- @field borderless boolean Remove all border visuals from the window (boolean)
--- @field resizable boolean Let the window be user-resizable (boolean)
--- @field fullscreen boolean Enable fullscreen (boolean)
--- @field fullscreentype FULL_SCREEN_TYPE Choose between "desktop" fullscreen or "exclusive" fullscreen mode (string)
local LoveConfigWindows = {}

--- @class LoveConfig
--- @field window LoveConfigWindows
local LoveConfig = {}

return LoveConfig