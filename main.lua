if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end
io.stdout:setvbuf("no")


function love.load()
    love.window.setFullscreen(true)
    love.mouse.setVisible(false)

    Paused = true
    Menu = true
    Game_Loop = false
    Score = 0

    Object = require "static.libs.classic"
    require "classes.Entity"
    require "classes.Bullet"
    require "classes.EntityHealth"
    require "classes.Moveable"
    require "classes.Player"
    require "classes.Enemy"
    require "classes.Cursor"
    require("static.menu")

    PistolSound = love.audio.newSource("static/sfx/glock18.wav", "static")

    Cursor = Cursor(5)
    PlayerCharacter = Player(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 100, 100, 15)
    Enemies = {}
    Bullets = {}
    Enemy_spawn_counter = 0
    Escape_Input_Check = true
end

function love.update(dt)
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
        if PlayerCharacter.current_hp <= 0 then
            Menu = "Game Over"
            Game_Loop = false
        end
        Enemy_spawn_counter = Enemy_spawn_counter + dt
        if Enemy_spawn_counter >= 1 then
            Enemy_spawner()
            Enemy_spawn_counter = 0
        end
        PlayerCharacter:update(dt)
        if love.mouse.isDown(1) then
            if PlayerCharacter:getRateOfFireTimer() <= 0 then
                local new_bullet = Bullet(3500)
                PlayerCharacter:resetRateOfFireTimer()
                local source = PistolSound:clone()
                love.audio.play(source)
                table.insert(Bullets, new_bullet)
            end
        end
        for _, enemy in ipairs(Enemies) do
            for j, bullet in ipairs(Bullets) do
                if CheckCollision(enemy, bullet) then
                    enemy.current_hp = enemy.current_hp - PlayerCharacter:getDamage()
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
    end
    if Menu then
        UpdateMenu()
    end
end

function love.draw()
    if not Menu or Menu == "Pause" then
        love.graphics.clear()
        PlayerCharacter:draw()
        for _, v in ipairs(Enemies) do
            v:draw()
        end
        for _, v in ipairs(Bullets) do
            v:draw(200)
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

function Enemy_spawner()
    local one = love.math.random(4)
    -- temporary, variable monster size in the future
    local radius = 64
    -- temporary, variable monster size in the future
    if (one == 1) then
        local two = love.math.random(love.graphics.getHeight())
        table.insert(Enemies, Enemy(0 - radius, two, 100, 50, 10))
    end
    if (one == 2) then
        local two = love.math.random(love.graphics.getHeight())
        table.insert(Enemies, Enemy(love.graphics.getWidth() + radius, two, 100, 50, 10))
    end
    if (one == 3) then
        local two = love.math.random(love.graphics.getWidth())
        table.insert(Enemies, Enemy(two, 0 - radius, 100, 50, 10))
    end
    if (one == 4) then
        local two = love.math.random(love.graphics.getWidth())
        table.insert(Enemies, Enemy(two, love.graphics.getHeight() + radius, 100, 50, 10))
    end
end

function love.keyreleased(key)
    if key == "escape" then
        Escape_Input_Check = true
    end
end
