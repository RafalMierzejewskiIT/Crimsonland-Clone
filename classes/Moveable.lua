Moveable = EntityHealth:extend()

function Moveable:new(x, y, hp, speed)
    Moveable.super.new(self, x, y, hp)
    self.speed = speed
end
