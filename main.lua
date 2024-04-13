if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end
io.stdout:setvbuf("no")


function love.load()
    love.window.setFullscreen(true)
    love.mouse.setVisible(false)
    font = love.graphics.newFont("static/fonts/Bebas-Regular.ttf", 64)

    Paused = true
    Menu = true
    Game_Loop = false
    Score = 0

    Object = require "static.libs.classic"
    require "classes.Entity"
    require "classes.EntityHealth"
    require "classes.Moveable"
    require "classes.Player"
    require "classes.Enemy"
    require "classes.Cursor"
    require("static.menu")

    Cursor = Cursor(5)
    Weapons:load()
    Enemies = {}
    Bullets = {}
    Enemy_spawn_counter = 0
    Escape_Input_Check = true
end

function love.update(dt)
    love.graphics.setFont(font)
    Cursor:update()
    if Game_Loop then
        if love.keyboard.isDown("escape") and Escape_Input_Check then
            if Menu == "Pause" then
                Menu = false
                Paused = false
            else
                Menu = "Pause"
                Paused = true
            end
            Escape_Input_Check = false
        end
    end
    if not Paused and Game_Loop then
        if love.keyboard.isDown("1") then
            Weapons:changeWeapon(1)
        end
        if love.keyboard.isDown("2") then
            Weapons:changeWeapon(2)
        end
        Enemy_spawn_counter = Enemy_spawn_counter + dt
        if Enemy_spawn_counter >= 1 then
            Enemy:spawn()
            Enemy_spawn_counter = 0
        end
        PlayerCharacter:update(dt)
        if love.mouse.isDown(1) then
            Weapons:fire()
        end
        Weapons:update(dt)
        for _, enemy in ipairs(Enemies) do
            for j, bullet in ipairs(Bullets) do
                if CheckCollision(enemy, bullet) then
                    enemy.current_hp = enemy.current_hp - bullet.damage
                    table.remove(Bullets, j)
                end
            end
        end
        for i, enemy in ipairs(Enemies) do
            enemy:update(dt)
            if enemy.delete then
                table.remove(Enemies, i)
                Score = Score + enemy.score
            end
        end
        for i, bullet in ipairs(Bullets) do
            bullet:update(dt)
            if bullet.delete then
                table.remove(Bullets, i)
            end
        end
        if PlayerCharacter.current_hp <= 0 then
            Menu = "Game Over"
            Game_Loop = false
        end
    end
    if Menu then
        UpdateMenu()
    end
end

function love.draw()
    if not Menu or Menu == "Pause" then
        PlayerCharacter:draw()
        for _, v in ipairs(Bullets) do
            v:draw(200)
        end
        for _, v in ipairs(Enemies) do
            v:draw()
        end
        love.graphics.printf("Score: " .. tostring(Score), 18, 0, 400)
    end
    if Menu then
        DrawMenu()
    end
    Cursor:draw()
end

function CheckCollision(object1, object2)
    local distance = math.sqrt((object1.x - object2.x) ^ 2 + (object1.y - object2.y) ^ 2)
    return distance < object1.radius + object2.radius
end

function GetDistance(x1, y1, x2, y2)
    local horizontal_distance = x1 - x2
    local vertical_distance = y1 - y2
    local a = horizontal_distance ^ 2
    local b = vertical_distance ^ 2

    local c = a + b
    local distance = math.sqrt(c)
    return distance
end

function love.keyreleased(key)
    if key == "escape" then
        Escape_Input_Check = true
    end
end
