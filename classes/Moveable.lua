Moveable = EntityHealth:extend()

function Moveable:new(x, y, hp, speed, angle)
    Moveable.super.new(self, x, y, hp)
    self.image = love.graphics.newImage("static/images/placeholder.png")
    self.speed = speed
    self.angle = angle
end
