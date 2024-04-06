require 'static.libs.simple-slider'

local starting_height = 200
local spacing = 50
local menu_mouseover_sound = love.audio.newSource("static/sfx/menu_mouseover.wav", "static")
local font = love.graphics.newFont("static/fonts/Bebas-Regular.ttf", 64)
love.graphics.setFont(font)
Menu = "Start"

StartGameButton = {}
StartGameButton.text = "Start Game"
StartGameButton.width = 300
StartGameButton.height = 80
StartGameButton.x = love.graphics:getWidth() / 2 - StartGameButton.width / 2
StartGameButton.y = starting_height
function StartGameButton:onClick()
    love.graphics.clear()
    Paused = false
    Menu = false
end

Options = {}
Options.text = "Options"
Options.width = 300
Options.height = 80
Options.x = love.graphics:getWidth() / 2 - Options.width / 2
Options.y = StartGameButton.y + StartGameButton.height + spacing
function Options:onClick()
    Menu = "Options"
end

ExitButton = {}
ExitButton.text = "Exit"
ExitButton.width = 300
ExitButton.height = 80
ExitButton.x = love.graphics:getWidth() / 2 - ExitButton.width / 2
ExitButton.y = Options.y + Options.height + spacing
function ExitButton:onClick()
    love.event.quit(0)
end

MasterVolumeText = {}
MasterVolumeText.text = "Master Volume"
MasterVolumeText.width = 400
MasterVolumeText.height = 80
MasterVolumeText.x = love.graphics:getWidth() / 2 - MasterVolumeText.width / 2
MasterVolumeText.y = starting_height
function MasterVolumeText:onClick()
end

Slider = newSlider(love.graphics:getWidth() / 2, MasterVolumeText.y + MasterVolumeText.height + spacing, 300, 50, 0, 1,
    function(v) love.audio.setVolume(v) end)

BackButton = {}
BackButton.text = "Back"
BackButton.width = 300
BackButton.height = 80
BackButton.x = love.graphics:getWidth() / 2 - BackButton.width / 2
BackButton.y = Slider.y + spacing
function BackButton:onClick()
    love.graphics.clear()
    Menu = "Start"
end

function UpdateMenu()
    if Menu == "Start" then
        Buttons = { StartGameButton, Options, ExitButton }
    end
    if Menu == "Options" then
        Buttons = { MasterVolumeText, BackButton }
    end
    local mx, my = love.mouse.getPosition()
    for _, button in ipairs(Buttons) do
        if mx > button.x and mx < button.x + button.width and
            my > button.y and my < button.y + button.height then
            button.mouseover = true
            if button.mouseoverSound == false then
                local source = menu_mouseover_sound:clone()
                love.audio.play(source)
                button.mouseoverSound = true
            end
            if love.mouse.isDown(1) and not PrevMouseClick then
                button:onClick()
            end
            PrevMouseClick = love.mouse.isDown(1)
        else
            button.mouseover = false
            button.mouseoverSound = false
        end
    end
    if Menu == "Options" then
        Slider:update()
    end
end

function DrawMenu()
    for _, button in ipairs(Buttons) do
        love.graphics.rectangle("line", button.x, button.y, button.width, button.height)
        if button.mouseover then
            love.graphics.setColor(0.25, 0.25, 0.25)
        else
            love.graphics.setColor(0.4, 0.4, 0.4)
        end
        love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(button.text, button.x, button.y, button.width, "center")
    end
    if Menu == "Options" then
        Slider:draw()
    end
end
