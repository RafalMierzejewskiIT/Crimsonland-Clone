if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end
io.stdout:setvbuf("no")


function love.load()
    love.window.setFullscreen(true)
    love.mouse.setVisible(false)
    MainFont = love.graphics.newFont("static/fonts/Bebas-Regular.ttf", 64)
    love.graphics.setFont(MainFont)

    Game_Loop = false
    Menu = true
    Score = 0

    Object = require "static.libs.classic"
    require "classes.Entity"
    require "classes.EntityHealth"
    require "classes.Moveable"
    require "classes.Player"
    require "classes.Enemy"
    require "classes.Cursor"
    require "static.menu"

    GameCursor = Cursor()
    Weapons:load()
end

function love.update(dt)
    GameCursor:update()
    if Game_Loop then
        if love.keyboard.isDown("escape") and not Input_check then
            if Menu == "Pause" then
                Menu = false
            else
                Menu = "Pause"
            end
        end
        Input_check = love.keyboard.isDown("escape")
    end
    if Menu ~= "Pause" and Game_Loop then
        PlayerCharacter:update(dt)
        Weapons:update(dt)
        Enemy:spawnUpdate(dt)
        for _, enemy in ipairs(Enemies) do
            for j = #Bullets, 1, -1 do
                if CheckCollision(enemy, Bullets[j]) then
                    enemy.current_hp = enemy.current_hp - Bullets[j].damage
                    table.remove(Bullets, j)
                end
            end
        end
        for i = #Enemies, 1, -1 do
            Enemies[i]:update(dt)
            if Enemies[i].delete then
                Score = Score + Enemies[i].score
                table.remove(Enemies, i)
            end
        end
        for i = #Bullets, 1, -1 do
            Bullets[i]:update(dt)
            if Bullets[i].delete then
                table.remove(Bullets, i)
            end
        end
        for i = #BulletTrails, 1, -1 do
            BulletTrails[i]:update(dt)
            if BulletTrails[i].delete then
                table.remove(BulletTrails, i)
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
    if Game_Loop then
        PlayerCharacter:draw()
        for _, v in ipairs(BulletTrails) do
            v:draw()
        end
        for _, v in ipairs(Bullets) do
            v:draw()
        end
        for _, v in ipairs(Enemies) do
            v:draw()
        end
        love.graphics.printf("Score: " .. tostring(Score), 18, 0, 400)
    end
    if Menu then
        DrawMenu()
    end
    GameCursor:draw()
end

function CheckCollision(object1, object2)
    local distance = GetDistance(object1.x, object1.y, object2.x, object2.y)
    return distance < object1.radius + object2.radius
end

function GetDistance(x1, y1, x2, y2)
    local a = (x1 - x2) ^ 2
    local b = (y1 - y2) ^ 2

    local c = a + b
    local distance = math.sqrt(c)
    return distance
end
