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

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Runs when the game starts, only once.
function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setTitle("Frappy Bird")

    math.randomseed(os.time())
end

-- Called by love2d whenever we resize the screen.
function love.resize(w, h)
    push:resize(w, h)
end

-- Keyboard entry handler, called each frame.
function love.keypressed(key)

end

--Called each frame, updates the game state components.
function love.update(dt)

end

-- Called each frame for drawing to the screen after the update or otherwise.
function love.draw()
    push:apply("start")

    push:apply("end")
end