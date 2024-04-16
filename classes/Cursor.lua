Cursor = Entity:extend()

local font = love.graphics.newFont("static/fonts/Bebas-Regular.ttf", 20)

function Cursor:new()
    self.x = love.mouse.getX()
    self.y = love.mouse.getY()
    self.default_radius = 5
    self.radius = 5
end

function Cursor:update()
    self.x = love.mouse.getX()
    self.y = love.mouse.getY()
    if not Menu then
        local distance = GetDistance(self.x, self.y, PlayerCharacter.x, PlayerCharacter.y)
        self.radius = SelectedWeapon.recoil_current * (distance / 100)
    end
end

function Cursor:draw()
    if Menu then
        love.graphics.circle("line", self.x, self.y, self.default_radius)
    else
        love.graphics.setColor(0, 0.7, 1)
        love.graphics.circle("line", self.x, self.y, self.radius)
        love.graphics.setColor(0, 1, 1)
        love.graphics.circle("line", self.x, self.y, self.default_radius)
        love.graphics.setFont(font)
        love.graphics.printf(tostring(SelectedWeapon.ammo_current), self.x - 20, self.y - 30, 40, "center")
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(MainFont)
    end
end
