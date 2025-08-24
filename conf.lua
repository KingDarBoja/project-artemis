--- Setup some configuration options before the LÖVE modules are loaded.
--- @param t LoveConfig Default configuration table.
function love.conf(t)
    t.window.title = 'Project Artemis'

    t.window.width = 1280
    t.window.height = 720

    t.window.resizable = true
    t.window.fullscreen = false
    t.window.fullscreentype = 'desktop'
end

