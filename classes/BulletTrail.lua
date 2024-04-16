BulletTrail = Object:extend()
BulletTrails = {}

function BulletTrail:new(px, py, x, y, max, frame)
    self.trail_max = max
    self.trail_current = 0
    self.px = px
    self.py = py
    self.x = x
    self.y = y
    self.delete = false
    self.trail_frame = frame
end

function BulletTrail:update()
    if self.trail_frame > 0 and self.trail_frame < 10 then
        self.trail_max = self.trail_frame * 3
    end
    if (self.trail_current < self.trail_max) then
        self.trail_current = self.trail_current + 1
    else
        self.delete = true
    end
end

function BulletTrail:draw()
    local color = 0.7 - ((self.trail_current - 1) / self.trail_max) * 0.7
    love.graphics.setColor(color, color, color)
    love.graphics.line(self.px, self.py, self.x, self.y)
    love.graphics.setColor(1, 1, 1)
end
