--[[
    Part of "S50's Intro to Game Development"
    Lecture 1
    
    -- Implementation of mobile game "Flappy Bird". --
    Made by: Daniel de Sousa
    https://github.com/daniellopes04
]]

-- Push library
-- https://github.com/Ulydev/push
push = require "push"

-- Class library
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require "class"

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage("sprites/background.png")
local ground = love.graphics.newImage("sprites/ground.png")

-- Runs when the game starts, only once.
function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setTitle("Frappy Bird")

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
end

-- Called by love2d whenever we resize the screen.
function love.resize(w, h)
    push:resize(w, h)
end

-- Keyboard entry handler, called each frame.
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

--Called each frame, updates the game state components.
function love.update(dt)

end

-- Called each frame for drawing to the screen after the update or otherwise.
function love.draw()
    push:start()

    love.graphics.draw(background, 0, 0)
    love.graphics.draw(ground, 0, VIRTUAL_HEIGHT - 16)

    push:finish()
end