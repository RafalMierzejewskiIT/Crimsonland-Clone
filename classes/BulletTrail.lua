BulletTrail = Object:extend()
BulletTrails = {}

function BulletTrail:new(px, py, x, y, time)
    self.px = px
    self.py = py
    self.x = x
    self.y = y
    self.time = time

    self.duration = 1
    self.max_brightness = 0.7
    self.offset = 0.015
    self.color = 0
    self.delete = false

    self.current = self.duration - self.time - self.offset
end

function BulletTrail:update(dt)
    self.current = self.current + (self.duration * dt)
    if self.current > self.duration then
        self.delete = true
        return
    end

    self.color = (((self.duration - self.current) / dt) / (self.time / dt)) * self.max_brightness
    if self.offset > 0 then
        self.offset = self.offset - dt
        self.color = self.max_brightness
    end
end

function BulletTrail:draw()
    love.graphics.setColor(self.color, self.color, self.color)
    love.graphics.line(self.px, self.py, self.x, self.y)
    love.graphics.setColor(1, 1, 1)
end
