Player = Moveable:extend()

function Player:new(x, y, hp, speed, level)
    Player.super.new(self, x, y, hp, speed)
    self.image = love.graphics.newImage("static/images/PC.png")
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.angle = math.atan2(Cursor:getY() - self.y, Cursor:getX() - self.x)
    self.radius = self.image:getWidth()
end

function Player:update(dt)
    self.angle = math.atan2(Cursor:getY() - self.y, Cursor:getX() - self.x)
    Player:movement(dt)
end

function Player:draw()
    if self.current_hp < 0 then
        self.current.hp = 0
    end

    hp_arc = -1.57 + ((self.current_hp / self.max_hp) * 6.29)
    love.graphics.setColor(0, 0.8, 1, 0.5)
    love.graphics.circle("fill", self.x, self.y, self.radius / 2 + 5)
    love.graphics.setColor(0, 0.8, 1)
    love.graphics.arc("fill", self.x, self.y, self.radius / 2 + 5, -1.57, hp_arc)
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", self.x, self.y, self.radius / 2 - 1)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.image, self.x, self.y, self.angle, 0.5, 0.5, self.width / 2, self.height / 2)
end

function Player:movement(dt)
    if love.keyboard.isDown("w") then
        self.y = self.y - self.speed * dt
    end
    if love.keyboard.isDown("s") then
        self.y = self.y + self.speed * dt
    end
    if love.keyboard.isDown("a") then
        self.x = self.x - self.speed * dt
    end
    if love.keyboard.isDown("d") then
        self.x = self.x + self.speed * dt
    end
end

function Player:getAngle()
    return self.angle
end

function Player:getHealth()
    return self.current_hp
end

function Player:takeDamage(damage)
    self.current_hp = self.current_hp - damage
end
