Entity = Object:extend()

function Entity:new(x, y)
    self.x = x
    self.y = y
    self.image = love.graphics.newImage("static/images/placeholder.png")
end

function Entity:draw()
    love.graphics.draw(self.image, self.x, self.y)
end
