Enemy = Moveable:extend()
Enemies = {}
Enemy_spawn_counter = 0

function Enemy:new(x, y, hp, speed, damage, rate_of_fire, image)
    Enemy.super.new(self, x, y, hp, speed)
    self.image = love.graphics.newImage(image)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.angle = math.atan2(PlayerCharacter.y - self.y, PlayerCharacter.x - self.x)
    self.radius = self.image:getWidth() / 2
    self.damage = damage
    self.rate_of_fire = rate_of_fire

    self.rate_of_fire_timer = 0
    self.score = 5
    self.EtoP_distance = self.radius + PlayerCharacter.radius
end

function Enemy:update(dt)
    if self.current_hp <= 0 then
        self.delete = true
        return
    end

    self.angle = math.atan2(PlayerCharacter.y - self.y, PlayerCharacter.x - self.x)
    local cos = math.cos(self.angle)
    local sin = math.sin(self.angle)
    local distance = GetDistance(self.x, self.y, PlayerCharacter.x, PlayerCharacter.y)

    if self.rate_of_fire_timer > 0 then
        self.rate_of_fire_timer = self.rate_of_fire_timer - dt
    end
    if distance > self.EtoP_distance then
        self.x = self.x + self.speed * cos * dt
        self.y = self.y + self.speed * sin * dt
    elseif self.rate_of_fire_timer <= 0 then
        PlayerCharacter.current_hp = PlayerCharacter.current_hp - self.damage
        self.rate_of_fire_timer = self.rate_of_fire
    end
end

function Enemy:draw()
    love.graphics.draw(self.image, self.x, self.y, self.angle, 1, 1, self.width / 2, self.height / 2)
end

function Enemy:spawnUpdate(dt)
    Enemy_spawn_counter = Enemy_spawn_counter + dt
    if Enemy_spawn_counter >= 1 then
        Enemy:spawn()
        Enemy_spawn_counter = 0
    end
end

function Enemy:spawn()
    local enemyType = love.math.random(10)
    local enemyHp = 0
    local enemySpeed = 0
    local enemyRadius = 0
    local enemyDamage = 0
    local enemyRateOfFire = 0
    local enemyImage = ""
    if enemyType == 1 then
        enemyHp = 50
        enemySpeed = 200
        enemyRadius = 48
        enemyDamage = 10
        enemyRateOfFire = 0.5
        enemyImage = "static/images/E_small.png"
    elseif enemyType == 10 then
        enemyHp = 200
        enemySpeed = 50
        enemyRadius = 80
        enemyDamage = 30
        enemyRateOfFire = 1.5
        enemyImage = "static/images/E_big.png"
    else
        enemyHp = 100
        enemySpeed = 100
        enemyRadius = 64
        enemyDamage = 20
        enemyRateOfFire = 1
        enemyImage = "static/images/E_normal.png"
    end
    local whichBorder = love.math.random(4)
    -- left border
    if (whichBorder == 1) then
        local borderPosition = love.math.random(love.graphics.getHeight())
        table.insert(Enemies,
            Enemy(0 - enemyRadius, borderPosition, enemyHp, enemySpeed, enemyDamage, enemyRateOfFire, enemyImage))
    end
    -- right border
    if (whichBorder == 2) then
        local borderPosition = love.math.random(love.graphics.getHeight())
        table.insert(Enemies,
            Enemy(love.graphics.getWidth() + enemyRadius, borderPosition, enemyHp, enemySpeed, enemyDamage,
                enemyRateOfFire, enemyImage))
    end
    -- top border
    if (whichBorder == 3) then
        local borderPosition = love.math.random(love.graphics.getWidth())
        table.insert(Enemies,
            Enemy(borderPosition, 0 - enemyRadius, enemyHp, enemySpeed, enemyDamage, enemyRateOfFire, enemyImage))
    end
    -- bottom border
    if (whichBorder == 4) then
        local borderPosition = love.math.random(love.graphics.getWidth())
        table.insert(Enemies,
            Enemy(borderPosition, love.graphics.getHeight() + enemyRadius, enemyHp, enemySpeed, enemyDamage,
                enemyRateOfFire, enemyImage))
    end
end
