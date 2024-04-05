Enemy = Moveable:extend()

function Enemy:new(x, y, hp, speed, damage)
    Enemy.super.new(self, x, y, hp, speed)
    self.image = love.graphics.newImage("static/images/E.png")
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.angle = math.atan2(Player:getY() - self.y, Player:getX() - self.x)
    self.radius = self.image:getWidth() / 2
    self.damage = damage
    self.rate_of_fire = 1
    self.rate_of_fire_timer = 0
end

function Enemy:update(dt)
    self.angle = math.atan2(Player:getY() - self.y, Player:getX() - self.x)

    local cos = math.cos(self.angle)
    local sin = math.sin(self.angle)
    local distance = GetDistance(self.x, self.y, Player:getX(), Player:getY())
    if self.rate_of_fire_timer > 0 then
        self.rate_of_fire_timer = self.rate_of_fire_timer - dt
    end
    if distance > 55 then
        self.x = self.x + self.speed * cos * dt
        self.y = self.y + self.speed * sin * dt
    elseif self.rate_of_fire_timer <= 0 then
        Player:takeDamage(self.damage)
        self.rate_of_fire_timer = self.rate_of_fire
    end
    if self.current_hp <= 0 then
        self.delete = true
    end
end

function Enemy:draw()
    love.graphics.draw(self.image, self.x, self.y, self.angle, 1, 1, self.width / 2, self.height / 2)
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
