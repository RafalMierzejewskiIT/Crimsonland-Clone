if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

function love.load()
    Object = require "static.libs.classic"
    require "classes.Entity"
    require "classes.Bullet"
    require "classes.EntityHealth"
    require "classes.Moveable"
    require "classes.Player"
    require "classes.Enemy"
    require "classes.Cursor"

    love.mouse.setVisible(false)
    Cursor = Cursor(5)
    Player = Player(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 100, 100)
    Enemies = { Enemy(0, 0, 100, 50) }
    Bullets = {}
end

function love.update(dt)
    Cursor:update()
    Player:update(dt)
    if love.mouse.isDown(1) then
        local new_bullet = Bullet(500)
        table.insert(Bullets, new_bullet)
    end
    for i, enemy in ipairs(Enemies) do
        for j, bullet in ipairs(Bullets) do
            if CheckCollision(enemy, bullet) then
                enemy.hp = enemy.hp - 1
                table.remove(Bullets, j)
            end
        end
    end
    for i, enemy in ipairs(Enemies) do
        enemy:update(dt)
        if enemy.delete then
            table.remove(Enemies, i)
        end
    end
    for i, bullet in ipairs(Bullets) do
        bullet:update(dt)
        if bullet.delete then
            table.remove(Bullets, i)
        end
    end
end

function love.draw()
    Cursor:draw()
    Player:draw()
    for i, v in ipairs(Enemies) do
        v:draw()
    end
    for i, v in ipairs(Bullets) do
        v:draw(200)
    end
end

function CheckCollision(object1, object2)
    local distance = math.sqrt((object1.x - object2.x) ^ 2 + (object1.y - object2.y) ^ 2)
    return distance < object1.radius + object2.radius
end
