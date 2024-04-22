BulletTrail = Object:extend()
BulletTrails = {}

function BulletTrail:new(px, py, x, y, time)
    self.px = px
    self.py = py
    self.x = x
    self.y = y
    self.duration = 1
    self.time = time
    self.current = 0
    self.offset = 0.015

    self.color = 0
    self.currentSetter = false
    self.delete = false
end

function BulletTrail:update(dt)
    self.current = self.current + (self.duration * dt)
    if self.current > self.duration then
        self.delete = true
        return
    end

    if not self.currentSetter then
        self.current = self.duration - self.time - self.offset
        self.currentSetter = true
    end

    self.color = (((self.duration - self.current) / dt) / (self.time / dt)) * 0.7
    if self.offset > 0 then
        self.offset = self.offset - dt
        self.color = 0.7
    end
end

function BulletTrail:draw()
    love.graphics.setColor(self.color, self.color, self.color)
    love.graphics.line(self.px, self.py, self.x, self.y)
    love.graphics.setColor(1, 1, 1)
end
