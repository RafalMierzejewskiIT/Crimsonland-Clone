BulletTrail = Object:extend()

function BulletTrail:new(px, py, x, y, max)
    self.trail_max = max
    self.trail_current = 0
    self.px = px
    self.py = py
    self.x = x
    self.y = y
    self.delete = false
    self.firstFrame = true
end

function BulletTrail:update()
    if (self.trail_current < self.trail_max) then
        self.trail_current = self.trail_current + 1
    else
        self.delete = true
    end
end

function BulletTrail:draw()
    local color = 0.6 - self.trail_current * 0.02
    love.graphics.setColor(color, color, color)
    love.graphics.line(self.px, self.py, self.x, self.y)
    love.graphics.setColor(1, 1, 1)
end
