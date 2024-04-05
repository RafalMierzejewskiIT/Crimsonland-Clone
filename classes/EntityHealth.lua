EntityHealth = Entity:extend()

function EntityHealth:new(x, y, hp)
    EntityHealth.super.new(self, x, y)
    self.image = love.graphics.newImage("static/images/placeholder.png")
    self.max_hp = hp
    self.current_hp = hp
end
