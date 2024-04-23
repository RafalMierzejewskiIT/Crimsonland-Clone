Player = Moveable:extend()
require "classes.Weapons"

function Player:new(x, y, hp, speed)
    Player.super.new(self, x, y, hp, speed)
    self.image = love.graphics.newImage("static/images/PC.png")
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.angle = math.atan2(GameCursor.y - self.y, GameCursor.x - self.x)
    self.radius = self.image:getWidth() / 2
end

function Player:update(dt)
    self.angle = math.atan2(GameCursor.y - self.y, GameCursor.x - self.x)

    PlayerCharacter:movement(dt)
    if love.keyboard.isDown("1") then
        Weapons:changeWeapon(1)
    end
    if love.keyboard.isDown("2") then
        Weapons:changeWeapon(2)
    end
    if love.mouse.isDown(1) then
        Weapons:fire()
    end
end

function Player:draw()
    if self.current_hp < 0 then
        self.current.hp = 0
    end

    local pi = 3.1415
    local hp_arc = ((self.current_hp / self.max_hp) * (pi * 2)) - (pi / 2)

    love.graphics.setColor(0, 0.8, 1, 0.5)
    love.graphics.circle("fill", self.x, self.y, self.radius * 2 + 5)
    love.graphics.setColor(0, 0.8, 1)
    love.graphics.arc("fill", self.x, self.y, self.radius * 2 + 5, -(pi / 2), hp_arc)
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", self.x, self.y, self.radius * 2 - 1)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.image, self.x, self.y, self.angle, 1, 1, self.width / 2, self.height / 2)
end

function Player:movement(dt)
    local dx = 0
    local dy = 0
    if love.keyboard.isDown("w") and PlayerCharacter.y > PlayerCharacter.radius then
        dy = -1
    end
    if love.keyboard.isDown("s") and PlayerCharacter.y < love.graphics.getHeight() - PlayerCharacter.radius then
        dy = 1
    end
    if love.keyboard.isDown("a") and PlayerCharacter.x > PlayerCharacter.radius then
        dx = -1
    end
    if love.keyboard.isDown("d") and PlayerCharacter.x < love.graphics.getWidth() - PlayerCharacter.radius then
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
