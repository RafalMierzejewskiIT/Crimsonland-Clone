if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

function love.load()
    Object = require "static.libs.classic"
    require "classes.Entity"
    require "classes.EntityHealth"
    require "classes.Moveable"
    require "classes.Player"
    require "classes.Enemy"
    require "classes.Cursor"

    love.mouse.setVisible(false)
    Cursor = Cursor(5)
    Player = Player(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 100, 100)
    Enemy = Enemy(0, 0, 100, 50)
end

function love.update(dt)
    Cursor:update()
    Player:update(dt)
    Enemy:update(dt)
end

function love.draw()
    Cursor:draw()
    Player:draw()
    Enemy:draw()
end
