Player = Moveable:extend()
require "classes.Weapons"

function Player:new(x, y, hp, speed)
    Player.super.new(self, x, y, hp, speed)
    self.image = love.graphics.newImage("static/images/PC.png")
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.angle = math.atan2(Cursor:getY() - self.y, Cursor:getX() - self.x)
    self.radius = self.image:getWidth()
    -- radius has bad value currently
    Weapons:changeWeapon(1)
end

function Player:update(dt)
    if SelectedWeapon.rate_of_fire_timer > 0 then
        SelectedWeapon.rate_of_fire_timer = SelectedWeapon.rate_of_fire_timer - dt
    end
    self.angle = math.atan2(Cursor:getY() - self.y, Cursor:getX() - self.x)
    PlayerCharacter:movement(dt)
end

function Player:draw()
    if self.current_hp < 0 then
        self.current.hp = 0
    end

    local hp_arc = -1.57 + ((self.current_hp / self.max_hp) * 6.29)
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
    local dx = 0
    local dy = 0
    if love.keyboard.isDown("w") and PlayerCharacter.y > PlayerCharacter.radius / 2 then
        dy = -1
    end
    if love.keyboard.isDown("s") and PlayerCharacter.y < love.graphics:getHeight() - PlayerCharacter.radius / 2 then
        dy = 1
    end
    if love.keyboard.isDown("a") and PlayerCharacter.x > PlayerCharacter.radius / 2 then
        dx = -1
    end
    if love.keyboard.isDown("d") and PlayerCharacter.x < love.graphics:getWidth() - PlayerCharacter.radius / 2 then
        dx = 1
    end
    if dx ~= 0 or dy ~= 0 then
        if dx ~= 0 and dy ~= 0 then
            dx = dx * 0.7071
            dy = dy * 0.7071
        end
        self.x = self.x + dx * self.speed * dt
        self.y = self.y + dy * self.speed * dt
    end
end

function Player:takeDamage(damage)
    self.current_hp = self.current_hp - damage
end
