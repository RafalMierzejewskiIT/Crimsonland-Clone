Cursor = Entity:extend()

local font = love.graphics.newFont("static/fonts/Bebas-Regular.ttf", 20)
love.graphics.setFont(font)

local function GetDistance(x1, y1, x2, y2)
    local horizontal_distance = x1 - x2
    local vertical_distance = y1 - y2
    local a = horizontal_distance ^ 2
    local b = vertical_distance ^ 2

    local c = a + b
    local distance = math.sqrt(c)
    return distance / 100
end

function Cursor:new(radius)
    self.x = love.mouse.getX()
    self.y = love.mouse.getY()
    self.default_radius = radius
    self.radius = radius
end

function Cursor:update()
    if not Menu then
        local distance = GetDistance(self.x, self.y, PlayerCharacter:getX(), PlayerCharacter:getY())
        self.radius = self.default_radius + SelectedWeapon.recoil_current * distance
    end
    self.x = love.mouse.getX()
    self.y = love.mouse.getY()
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
    end
end
