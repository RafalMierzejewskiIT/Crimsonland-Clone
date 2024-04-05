Moveable = EntityHealth:extend()

function Moveable:new(x, y, hp, speed)
    Moveable.super.new(self, x, y, hp)
    self.image = love.graphics.newImage("static/images/placeholder.png")
    self.speed = speed
end
