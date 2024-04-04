Cursor = Entity:extend()

function Cursor:new(radius)
    self.x = love.mouse.getX()
    self.y = love.mouse.getY()
    self.radius = radius
end

function Cursor:update()
    self.x = love.mouse.getX()
    self.y = love.mouse.getY()
end

function Cursor:draw()
    love.graphics.circle("line", self.x, self.y, self.radius)
end
