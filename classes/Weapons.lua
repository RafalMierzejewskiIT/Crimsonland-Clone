Weapons = Object:extend()

Weapons_Array = {}
require "classes.Bullet"
require "classes.BulletTrail"

function Weapons:new(name, rate_of_fire, reload_time, ammo_max,
                     recoil_max, recoil_buildup, recoil_decay,
                     bullet_damage, bullet_speed,
                     sound_fire, sound_reloadStart, sound_reloadEnd)
    self.name = name
    self.rate_of_fire = rate_of_fire
    self.rate_of_fire_timer = rate_of_fire
    self.reload_time = reload_time
    self.reload_timer = reload_time
    self.ammo_max = ammo_max
    self.ammo_current = ammo_max
    self.recoil_current = 0
    self.recoil_max = recoil_max
    self.recoil_buildup = recoil_buildup
    self.recoil_decay = recoil_decay
    self.bullet_damage = bullet_damage
    self.bullet_speed = bullet_speed
    self.sound_fire = sound_fire
    self.sound_reloadStart = sound_reloadStart
    self.sound_reloadEnd = sound_reloadEnd
    self.sound_reloadStart_played = false
end

function Weapons:load()
    Weapon_instance = Weapons("Pistol", 0.3, 0.75, 12, 5, 5, 0.25, 30, 3500,
        love.audio.newSource("static/sfx/glock18.wav", "static"),
        love.audio.newSource("static/sfx/reload_start.wav", "static"),
        love.audio.newSource("static/sfx/reload_end.wav", "static"))
    table.insert(Weapons_Array, Weapon_instance)
    Weapon_instance = Weapons("MP5", 0.05, 0.75, 30, 5, 1, 0.15, 10, 3500,
        love.audio.newSource("static/sfx/mp5.wav", "static"),
        love.audio.newSource("static/sfx/reload_start.wav", "static"),
        love.audio.newSource("static/sfx/reload_end.wav", "static"))
    table.insert(Weapons_Array, Weapon_instance)
    SelectedWeapon = Weapons_Array[1]
end

function Weapons:update(dt)
    if SelectedWeapon.ammo_current == 0 then
        SelectedWeapon:reload(dt)
    end
    for _, wpn in ipairs(Weapons_Array) do
        if wpn.recoil_current > 0 then
            wpn.recoil_current = wpn.recoil_current - wpn.recoil_decay
        end
        if wpn.recoil_current < 0 then
            wpn.recoil_current = 0
        end
        if wpn.recoil_current > wpn.recoil_max then
            wpn.recoil_current = wpn.recoil_max
        end
    end
end

function Weapons:fire()
    if SelectedWeapon.rate_of_fire_timer <= 0 and SelectedWeapon.ammo_current > 0 then
        local new_bullet = Bullet(SelectedWeapon.bullet_speed, SelectedWeapon.bullet_damage)
        SelectedWeapon.rate_of_fire_timer = SelectedWeapon.rate_of_fire
        local source = SelectedWeapon.sound_fire:clone()
        love.audio.play(source)
        table.insert(Bullets, new_bullet)
        SelectedWeapon.ammo_current = SelectedWeapon.ammo_current - 1
        SelectedWeapon.recoil_current = SelectedWeapon.recoil_current + SelectedWeapon.recoil_buildup
    end
end

function Weapons:reload(dt)
    if SelectedWeapon.sound_reloadStart_played == false then
        love.audio.play(SelectedWeapon.sound_reloadStart)
        SelectedWeapon.sound_reloadStart_played = true
    end
    if SelectedWeapon.reload_timer >= 0 then
        SelectedWeapon.reload_timer = SelectedWeapon.reload_timer - dt
    else
        love.audio.play(SelectedWeapon.sound_reloadEnd)
        SelectedWeapon.ammo_current = SelectedWeapon.ammo_max
        SelectedWeapon.reload_timer = SelectedWeapon.reload_time
        SelectedWeapon.sound_reloadStart_played = false
    end
end

function Weapons:changeWeapon(selectedWeaponId)
    SelectedWeapon.reload_timer = SelectedWeapon.reload_time
    SelectedWeapon.sound_reloadStart_played = false
    SelectedWeapon = Weapons_Array[selectedWeaponId]
end
