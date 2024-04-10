Weapon = {}
require "classes.Bullet"

function Weapon:changeWeapon(id)
    if id == 0 then
        Weapon.name = "Pistol"
        Weapon.rate_of_fire = 0.3
        Weapon.rate_of_fire_timer = 0
        Weapon.reload_time = 0.75
        Weapon.reload_timer = Weapon.reload_time
        Weapon.max_ammo = 12
        Weapon.current_ammo = Weapon.max_ammo
        Weapon.recoil_current = 0
        Weapon.recoil_max = 5
        Weapon.recoil_buildup = 5
        Weapon.recoil_decay = 0.25
        Weapon.bullet_damage = 30
        Weapon.bullet_speed = 3500
        Weapon.sound_fire = love.audio.newSource("static/sfx/glock18.wav", "static")
        Weapon.sound_reloadStart = love.audio.newSource("static/sfx/reload_start.wav", "static")
        Weapon.sound_reloadEnd = love.audio.newSource("static/sfx/reload_end.wav", "static")
        Weapon.sound_reloadStart_played = false
    end
    if id == 1 then
        Weapon.name = "MP5"
        Weapon.rate_of_fire = 0.05
        Weapon.rate_of_fire_timer = 0
        Weapon.reload_time = 0.75
        Weapon.reload_timer = Weapon.reload_time
        Weapon.max_ammo = 30
        Weapon.current_ammo = Weapon.max_ammo
        Weapon.recoil_current = 0
        Weapon.recoil_max = 5
        Weapon.recoil_buildup = 1
        Weapon.recoil_decay = 0.15
        Weapon.bullet_damage = 10
        Weapon.bullet_speed = 3500
        Weapon.sound_fire = love.audio.newSource("static/sfx/mp5.wav", "static")
        Weapon.sound_reloadStart = love.audio.newSource("static/sfx/reload_start.wav", "static")
        Weapon.sound_reloadEnd = love.audio.newSource("static/sfx/reload_end.wav", "static")
        Weapon.sound_reloadStart_played = false
    end
end

function Weapon:update(dt)
    if Weapon.current_ammo == 0 then
        Weapon:reload(dt)
    end
    if Weapon.recoil_current > 0 then
        Weapon.recoil_current = Weapon.recoil_current - Weapon.recoil_decay
    end
    if Weapon.recoil_current < 0 then
        Weapon.recoil_current = 0
    end
    if Weapon.recoil_current > Weapon.recoil_max then
        Weapon.recoil_current = Weapon.recoil_max
    end
end

function Weapon:fire()
    if Weapon.rate_of_fire_timer <= 0 and Weapon.current_ammo > 0 then
        local new_bullet = Bullet(Weapon.bullet_speed, Weapon.bullet_damage)
        Weapon.rate_of_fire_timer = Weapon.rate_of_fire
        local source = Weapon.sound_fire:clone()
        love.audio.play(source)
        table.insert(Bullets, new_bullet)
        Weapon.current_ammo = Weapon.current_ammo - 1
        Weapon.recoil_current = Weapon.recoil_current + Weapon.recoil_buildup
    end
end

function Weapon:reload(dt)
    if Weapon.sound_reloadStart_played == false then
        love.audio.play(Weapon.sound_reloadStart)
        Weapon.sound_reloadStart_played = true
    end
    if Weapon.reload_timer >= 0 then
        Weapon.reload_timer = Weapon.reload_timer - dt
    else
        love.audio.play(Weapon.sound_reloadEnd)
        Weapon.current_ammo = Weapon.max_ammo
        Weapon.reload_timer = Weapon.reload_time
        Weapon.sound_reloadStart_played = false
    end
end
