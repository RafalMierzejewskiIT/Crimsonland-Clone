Enemy = Moveable:extend()

function Enemy:new(x, y, hp, speed)
    Moveable.super.new(self, x, y, hp)
    self.image = love.graphics.newImage("static/images/E.png")
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.speed = speed
    self.movement_angle = math.atan2(Player:getY() - self.y, Player:getX() - self.x)
end

function Enemy:update(dt)
    self.angle = math.atan2(Player:getY() - self.y, Player:getX() - self.x)

    local cos = math.cos(self.angle)
    local sin = math.sin(self.angle)
    local distance = GetDistance(self.x, self.y, Player:getX(), Player:getY())
    if distance > 55 then
        Enemy.x = Enemy.x + Enemy.speed * cos * dt
        Enemy.y = Enemy.y + Enemy.speed * sin * dt
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
