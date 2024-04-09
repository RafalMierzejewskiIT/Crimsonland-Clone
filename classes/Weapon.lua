Weapon = {}

function Weapon:changeWeapon(id)
    if id == 0 then
        Weapon.damage = 25
        Weapon.rate_of_fire = 0.25
        Weapon.rate_of_fire_timer = 0
        Weapon.reload_time = 0.5
        Weapon.max_ammo = 12
        Weapon.current_ammo = Weapon.max_ammo
        Weapon.recoil_current = 0
        Weapon.recoil_max = 1
        Weapon.recoil_buildup = 0.1
        Weapon.sound = love.audio.newSource("static/sfx/glock18.wav", "static")
    end
    if id == 1 then
        Weapon.damage = 10
        Weapon.rate_of_fire = 0.05
        Weapon.rate_of_fire_timer = 0
        Weapon.reload_time = 0.5
        Weapon.max_ammo = 12
        Weapon.current_ammo = Weapon.max_ammo
        Weapon.recoil_current = 0
        Weapon.recoil_max = 1
        Weapon.recoil_buildup = 0.1
        Weapon.sound = love.audio.newSource("static/sfx/mp5.wav", "static")
    end
end

function Weapon:fire()
end
