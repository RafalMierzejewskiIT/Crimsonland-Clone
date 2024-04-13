Bullet = Entity:extend()

function Bullet:new(speed, damage)
    local recoil = love.math.random(-SelectedWeapon.recoil_current, SelectedWeapon.recoil_current)

    self.angle = math.atan2(Cursor:getY() - PlayerCharacter:getY(), Cursor:getX() - PlayerCharacter:getX()) +
        recoil * 0.01
    local cos = math.cos(self.angle)
    local sin = math.sin(self.angle)
    self.x = PlayerCharacter:getX() + 20 * cos
    self.y = PlayerCharacter:getY() + 20 * sin
    self.image = love.graphics.newImage("static/images/bullet.png")
    self.speed = speed
    self.radius = 1
    self.damage = damage
    -- self.trail_current = 0
    -- self.trail_max = 3
    -- self.trail_timer = 1
end

function Bullet:update(dt)
    local cos = math.cos(self.angle)
    local sin = math.sin(self.angle)
    self.x = self.x + self.speed * cos * dt
    self.y = self.y + self.speed * sin * dt

    if self.x < 0 or self.x > love.graphics.getWidth() or self.y < 0 or self.y > love.graphics.getHeight() then
        self.delete = true
    end
end

function Bullet:draw()
    love.graphics.draw(self.image, self.x, self.y, self.angle)
end
