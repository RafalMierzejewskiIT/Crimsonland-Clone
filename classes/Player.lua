Player = Moveable:extend()

function Player:new(x, y, hp, speed, level)
    Moveable.super.new(self, x, y, hp, speed)
    self.image = love.graphics.newImage("static/images/PC.png")
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.speed = speed
end

function Player:update(dt)
    self.angle = math.atan2(self.y - Cursor:getY(), self.x - Cursor:getX())
    Player:movement(dt)
end

function Player:draw()
    love.graphics.draw(self.image, self.x, self.y, self.angle, 1, 1, self.width / 2, self.height / 2)
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
